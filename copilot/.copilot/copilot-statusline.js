#!/usr/bin/env node

// Copilot CLI status line: shows context usage + session cost in USD.
// Pricing sourced from
// https://docs.github.com/en/copilot/reference/copilot-billing/models-and-pricing
// (USD per 1M tokens). Update as new models ship.
const PRICING = {
  // OpenAI
  "GPT-4.1": { in: 2.0, cached: 0.5, out: 8.0 },
  "GPT-5 mini": { in: 0.25, cached: 0.025, out: 2.0 },
  "GPT-5.2": { in: 1.75, cached: 0.175, out: 14.0 },
  "GPT-5.2-Codex": { in: 1.75, cached: 0.175, out: 14.0 },
  "GPT-5.3-Codex": { in: 1.75, cached: 0.175, out: 14.0 },
  "GPT-5.4": { in: 2.5, cached: 0.25, out: 15.0 },
  "GPT-5.4 mini": { in: 0.75, cached: 0.075, out: 4.5 },
  "GPT-5.4 nano": { in: 0.2, cached: 0.02, out: 1.25 },
  "GPT-5.5": { in: 5.0, cached: 0.5, out: 30.0 },

  // Anthropic (cache write priced separately)
  "Claude Haiku 4.5": { in: 1.0, cached: 0.1, write: 1.25, out: 5.0 },
  "Claude Sonnet 4": { in: 3.0, cached: 0.3, write: 3.75, out: 15.0 },
  "Claude Sonnet 4.5": { in: 3.0, cached: 0.3, write: 3.75, out: 15.0 },
  "Claude Sonnet 4.6": { in: 3.0, cached: 0.3, write: 3.75, out: 15.0 },
  "Claude Opus 4.5": { in: 5.0, cached: 0.5, write: 6.25, out: 25.0 },
  "Claude Opus 4.6": { in: 5.0, cached: 0.5, write: 6.25, out: 25.0 },
  "Claude Opus 4.7": { in: 5.0, cached: 0.5, write: 6.25, out: 25.0 },

  // Google
  "Gemini 2.5 Pro": { in: 1.25, cached: 0.125, out: 10.0 },
  "Gemini 3 Flash": { in: 0.5, cached: 0.05, out: 3.0 },
  "Gemini 3.1 Pro": { in: 2.0, cached: 0.2, out: 12.0 },
};

// Map raw model.id values (and variants like -1m, -high) to their canonical
// display-name key in PRICING. Anything not listed falls back to display_name
// matching via lookupPricing().
const MODEL_ID_TO_NAME = {
  // Anthropic
  "claude-haiku-4.5": "Claude Haiku 4.5",
  "claude-sonnet-4": "Claude Sonnet 4",
  "claude-sonnet-4.5": "Claude Sonnet 4.5",
  "claude-sonnet-4.6": "Claude Sonnet 4.6",
  "claude-opus-4.5": "Claude Opus 4.5",
  "claude-opus-4.6": "Claude Opus 4.6",
  "claude-opus-4.7": "Claude Opus 4.7",
  // OpenAI
  "gpt-4.1": "GPT-4.1",
  "gpt-5-mini": "GPT-5 mini",
  "gpt-5.2": "GPT-5.2",
  "gpt-5.2-codex": "GPT-5.2-Codex",
  "gpt-5.3-codex": "GPT-5.3-Codex",
  "gpt-5.4": "GPT-5.4",
  "gpt-5.4-mini": "GPT-5.4 mini",
  "gpt-5.4-nano": "GPT-5.4 nano",
  "gpt-5.5": "GPT-5.5",
  // Google
  "gemini-2.5-pro": "Gemini 2.5 Pro",
  "gemini-3-flash": "Gemini 3 Flash",
  "gemini-3.1-pro": "Gemini 3.1 Pro",
};

function lookupPricingById(id) {
  if (!id) return null;
  // Strip common variant suffixes: -1m, -1m-internal, -internal, -high, -xhigh
  const base = String(id)
    .toLowerCase()
    .replace(/-(1m(-internal)?|high|xhigh|internal)$/g, "");
  const name = MODEL_ID_TO_NAME[base];
  return name ? PRICING[name] : null;
}

function normalizeModelName(name) {
  if (!name) return null;
  return String(name)
    .replace(/\s*\([^)]*\)/g, "")
    .trim();
}

function lookupPricing(displayName) {
  const norm = normalizeModelName(displayName);
  if (!norm) return null;
  if (PRICING[norm]) return PRICING[norm];
  // Loose match: e.g. "Claude Opus 4.7 1M context" → "Claude Opus 4.7"
  let best = null;
  for (const key of Object.keys(PRICING)) {
    if (norm.startsWith(key) && (!best || key.length > best.length)) best = key;
  }
  return best ? PRICING[best] : null;
}

// Read per-session metrics from local CLI state:
//   1. files modified — from ~/.copilot/session-store.db (session_files table:
//      one deduped row per file touched by edit/create, with tool_name).
//   2. per-model output tokens — from events.jsonl (assistant.message events).
//      Read incrementally with on-disk caching so the 200 ms tick stays fast.
function readSessionMetrics(sessionId) {
  if (!sessionId) return null;
  const fs = require("fs");
  const path = require("path");
  const os = require("os");
  const result = { filesCount: 0, outByModel: {} };

  // --- 1. files modified (SQLite, fast and authoritative) ---
  try {
    process.removeAllListeners("warning"); // silence node:sqlite experimental warning
    const { DatabaseSync } = require("node:sqlite");
    const dbPath = path.join(os.homedir(), ".copilot/session-store.db");
    const db = new DatabaseSync(dbPath, { readOnly: true });
    try {
      const row = db
        .prepare(
          "SELECT COUNT(DISTINCT file_path) AS n FROM session_files WHERE session_id = ?",
        )
        .get(sessionId);
      result.filesCount = Number(row?.n || 0);
    } finally {
      db.close();
    }
  } catch {
    // If sqlite or the db are unavailable, fall back to zero.
  }

  // --- 2. per-model output tokens (events.jsonl, incremental + cached) ---
  const eventsPath = path.join(
    os.homedir(),
    ".copilot/session-state",
    sessionId,
    "events.jsonl",
  );
  let st;
  try {
    st = fs.statSync(eventsPath);
  } catch {
    return result;
  }
  // Safety cap: skip if events.jsonl is huge (>20 MB).
  if (st.size > 20 * 1024 * 1024) return result;

  const cacheDir = path.join(os.tmpdir(), "copilot-statusline-cache");
  const cachePath = path.join(cacheDir, `${sessionId}.json`);
  let cache = { mtimeMs: 0, offset: 0, outByModel: {} };
  try {
    cache = JSON.parse(fs.readFileSync(cachePath, "utf8"));
  } catch {}

  // If file shrank or its mtime went backwards, the session was rotated.
  if (st.size < cache.offset || st.mtimeMs < cache.mtimeMs) {
    cache = { mtimeMs: 0, offset: 0, outByModel: {} };
  }

  if (st.size > cache.offset) {
    let fd;
    try {
      fd = fs.openSync(eventsPath, "r");
      const len = st.size - cache.offset;
      const buf = Buffer.alloc(len);
      fs.readSync(fd, buf, 0, len, cache.offset);
      const text = buf.toString("utf8");
      const newlineEnd = text.lastIndexOf("\n");
      // Only parse complete lines; keep offset before any partial trailing line.
      const parsable = newlineEnd >= 0 ? text.slice(0, newlineEnd + 1) : "";
      const consumed = Buffer.byteLength(parsable, "utf8");
      for (const line of parsable.split("\n")) {
        if (!line) continue;
        let e;
        try {
          e = JSON.parse(line);
        } catch {
          continue;
        }
        if (
          e.type === "assistant.message" &&
          e.data?.outputTokens &&
          e.data?.model
        ) {
          const m = e.data.model;
          cache.outByModel[m] =
            (cache.outByModel[m] || 0) + e.data.outputTokens;
        }
      }
      cache.offset += consumed;
      cache.mtimeMs = st.mtimeMs;
      try {
        fs.mkdirSync(cacheDir, { recursive: true });
        fs.writeFileSync(cachePath, JSON.stringify(cache));
      } catch {}
    } catch {
      // ignore read errors; cached values remain valid
    } finally {
      if (fd != null) try { fs.closeSync(fd); } catch {}
    }
  }

  result.outByModel = cache.outByModel;
  return result;
}

function computeCost(data, metrics) {
  const ctx = data.context_window || {};
  const model = data.model || {};
  const totalInput = ctx.total_input_tokens || 0;
  const totalCacheR = ctx.total_cache_read_tokens || 0;
  const totalCacheW = ctx.total_cache_write_tokens || 0;
  const totalOutput = ctx.total_output_tokens || 0;
  const totalReason = ctx.total_reasoning_tokens || 0;

  const outByModel = metrics?.outByModel || {};
  const outModelSum = Object.values(outByModel).reduce((a, b) => a + b, 0);

  // Fallback (single-model accounting) when we don't have per-model output
  // data, or when the per-model events don't account for any of the cumulative
  // output tokens reported in the payload.
  const fallback = () => {
    const p = lookupPricing(model.display_name) || lookupPricing(model.id);
    if (!p) return null;
    return (
      (totalInput * p.in +
        totalCacheR * p.cached +
        totalCacheW * (p.write ?? p.in) +
        (totalOutput + totalReason) * p.out) /
      1_000_000
    );
  };
  if (outModelSum === 0) return fallback();

  // Per-model accounting: bill each model's output (and reasoning) at its own
  // rate, and apportion the cumulative input + cache tokens by each model's
  // output share. This is a heuristic because the payload doesn't expose
  // per-model input/cache totals during a live session — but it's strictly
  // more accurate than billing all tokens at the currently selected model.
  let cost = 0;
  let anyPriced = false;
  for (const [mid, outTokens] of Object.entries(outByModel)) {
    const p = lookupPricingById(mid) || lookupPricing(mid);
    if (!p) continue;
    anyPriced = true;
    const share = outTokens / outModelSum;
    const reasoningShare = totalReason * share;
    cost +=
      (totalInput * p.in * share +
        totalCacheR * p.cached * share +
        totalCacheW * (p.write ?? p.in) * share +
        (outTokens + reasoningShare) * p.out) /
      1_000_000;
  }
  if (!anyPriced) return fallback();
  return cost;
}

function fmtTokens(n) {
  if (!n) return "0";
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
  if (n >= 1000) return `${Math.round(n / 1000)}k`;
  return String(n);
}

function fmtCost(c) {
  if (c == null) return null;
  if (c < 0.01) return "<$0.01";
  if (c < 10) return `$${c.toFixed(2)}`;
  if (c < 100) return `$${c.toFixed(1)}`;
  return `$${Math.round(c)}`;
}

function renderBar(pct, width = 10) {
  const filled = Math.max(0, Math.min(width, Math.round((pct / 100) * width)));
  const empty = width - filled;
  // Fill color shifts with usage: light blue → yellow → red.
  let fillRgb, trackRgb;
  if (pct >= 90) {
    fillRgb = "224;90;90"; // red
    trackRgb = "70;40;40";
  } else if (pct >= 70) {
    fillRgb = "230;195;90"; // yellow
    trackRgb = "70;60;40";
  } else {
    fillRgb = "120;180;230"; // light blue
    trackRgb = "45;55;70";
  }
  const FG = `\x1b[48;2;${fillRgb}m`;
  const BG = `\x1b[48;2;${trackRgb}m`;
  const RESET = "\x1b[0m";
  return FG + " ".repeat(filled) + BG + " ".repeat(empty) + RESET;
}

let input = "";
process.stdin.on("data", (chunk) => (input += chunk));
process.stdin.on("end", () => {
  let data = {};
  try {
    data = JSON.parse(input);
  } catch {
    /* empty/invalid payload */
  }

  const ctx = data.context_window || {};
  const used = ctx.current_context_tokens ?? ctx.total_tokens ?? 0;
  const limit = ctx.displayed_context_limit ?? ctx.context_window_size ?? 0;
  const pct = limit > 0 ? Math.min(100, Math.round((used / limit) * 100)) : 0;

  let metrics = null;
  try {
    metrics = readSessionMetrics(data.session_id);
  } catch {
    /* fall back to payload-only */
  }

  const cost = computeCost(data, metrics);
  const costStr = fmtCost(cost);
  const inFresh = ctx.total_input_tokens || 0;
  const cacheRead = ctx.total_cache_read_tokens || 0;
  const cacheWrite = ctx.total_cache_write_tokens || 0;
  const totalIn = inFresh + cacheRead + cacheWrite;
  const totalOut = (ctx.total_output_tokens || 0) + (ctx.total_reasoning_tokens || 0);

  const segments = [
    `Context ${fmtTokens(used)}/${fmtTokens(limit)}`,
    ` ${renderBar(pct)}`,
    ` ${pct}%`,
  ];
  if (costStr || totalIn || totalOut) {
    const parts = [];
    if (totalIn) parts.push(`↑${fmtTokens(totalIn)}`);
    if (cacheRead) parts.push(`⊚${fmtTokens(cacheRead)}`);
    if (totalOut) parts.push(`↓${fmtTokens(totalOut)}`);
    if (costStr) parts.push(`(${costStr})`);
    segments.push(` · ${parts.join(" ")}`);
  }

  const cost_ = data.cost || {};
  const added = cost_.total_lines_added || 0;
  const removed = cost_.total_lines_removed || 0;
  const filesCount = metrics?.filesCount || 0;
  if (added || removed || filesCount) {
    const GREEN = "\x1b[38;2;152;195;121m";
    const RED = "\x1b[38;2;224;108;117m";
    const DIM = "\x1b[2m";
    const RESET = "\x1b[0m";
    let changes = ` · ${GREEN}+${added}${RESET}/${RED}-${removed}${RESET}`;
    if (filesCount) changes += ` ${DIM}in ${filesCount} file${filesCount === 1 ? "" : "s"}${RESET}`;
    segments.push(changes);
  }

  process.stdout.write(segments.join(""));
});

