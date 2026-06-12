# Global instructions

## Environment

- macOS and Linux (cross-platform). Use platform guards when needed.
- Default editor: vim
- Shell: zsh (with oh-my-zsh), bash as fallback
- Terminal: Ghostty
- Locale: en_US.UTF-8, timezone Europe/Paris

## Coding preferences

- Prefer concise, readable code over clever abstractions
- Use standard library or well-maintained dependencies; avoid unnecessary bloat
- Follow existing project conventions before introducing new patterns
- When writing shell scripts: use POSIX sh where possible, bash/zsh only when necessary
- Commit messages: imperative mood, concise subject line (50 chars), body if needed

## Commit Attribution

When committing on my behalf, use the Linux kernel convention for AI
coding assistant attribution (see
https://github.com/torvalds/linux/blob/master/Documentation/process/coding-assistants.rst):

Format: `Assisted-by: AGENT_NAME:MODEL_VERSION [TOOL1] [TOOL2]`

Where:
- AGENT_NAME is the AI tool or framework; defaults to GitHub Copilot unless specified otherwise
- MODEL_VERSION is the specific model used (e.g. gpt-4o, claude-opus-4.6)
- [TOOL1] [TOOL2] are optional specialized tools used (e.g. coccinelle, sparse)

Use your actual model version. Basic development tools
(git, gcc, make, editors) should not be listed.

Do not use `Co-authored-by:` for AI-assisted work.

## Communication style

- Be direct and concise; skip pleasantries and filler
- Do not use emojis unless explicitly asked
- Explain trade-offs when multiple approaches exist
- When uncertain, say so rather than guessing

## Tools

- Git for version control; prefer rebase over merge for local work
- GNU Make, shell scripts for build automation
- Docker/Podman for containerized workflows
- Homebrew (macOS), apt (Debian/Ubuntu) for system packages
- Test, format, and style tools as defined by the project (e.g. pytest, go test, black, prettier, eslint, shellcheck, scalastyle, clippy, rustfmt, etc)
