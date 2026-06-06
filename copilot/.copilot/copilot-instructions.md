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
