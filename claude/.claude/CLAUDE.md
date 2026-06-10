# Global Claude Code Instructions

## Commit Attribution

When committing on my behalf, use the Linux kernel convention for AI
coding assistant attribution (see
https://github.com/torvalds/linux/blob/master/Documentation/process/coding-assistants.rst):

Format: `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]`

Where:
- AGENT_NAME is the AI tool or framework (e.g. Claude Code, Copilot)
- MODEL_VERSION is the specific model used (e.g. claude-opus-4, claude-sonnet-4)
- [TOOL1] [TOOL2] are optional specialized tools used (e.g. coccinelle, sparse)

Use your actual agent name and model version. Basic development tools
(git, gcc, make, editors) should not be listed.

Do not use `Co-authored-by:` for AI-assisted work.

## Commit Messages

- Write concise commit messages
- First line: short summary (50 chars or less ideally, 72 max)
- Body: explain what and why, not how
- Do not write verbose AI-sounding commit descriptions

## Communication style

- Be direct and concise; skip pleasantries and filler
- Do not use emojis unless explicitly asked
- Explain trade-offs when multiple approaches exist
- When uncertain, say so rather than guessing

## Coding preferences

- Prefer concise, readable code over clever abstractions
- Follow existing project conventions before introducing new patterns
- Use standard library or well-maintained dependencies; avoid unnecessary bloat
