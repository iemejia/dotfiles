# ~/.bash_profile: executed by bash(1) for login shells.
# Sources ~/.profile for POSIX-compatible setup, then ~/.bashrc for
# interactive shell config (aliases, functions, completions, etc.).

. "$HOME/.profile"

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
