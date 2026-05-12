# Environment variables and PATH setup - fish equivalent of ~/.profile
# Ensures all env vars are available even when fish is a login shell (SSH, TTY)

set -gx TZ Europe/Paris

set -gx TERM xterm-256color
set -gx GIT_EDITOR vim
set -gx SVN_EDITOR vim
set -gx IRC_CLIENT irssi

set -gx EDITOR vim
if test -f /usr/share/source-highlight/src-hilite-lesspipe.sh
    set -gx LESSOPEN "| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
else if test -f /opt/homebrew/bin/src-hilite-lesspipe.sh
    set -gx LESSOPEN "| /opt/homebrew/bin/src-hilite-lesspipe.sh %s"
else if test -f /usr/local/bin/src-hilite-lesspipe.sh
    set -gx LESSOPEN "| /usr/local/bin/src-hilite-lesspipe.sh %s"
end
set -gx LESS '-C -M -I -j 10 -# 4 -R'
set -gx PAGER less

# UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# Telemetry opt-outs
set -gx DO_NOT_TRACK 1
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx SAM_CLI_TELEMETRY 0
set -gx AZURE_CORE_COLLECT_TELEMETRY 0
set -gx HOMEBREW_NO_ANALYTICS 1

set -gx FORCE_COLOR 1

# Proton/gaming
set -gx PROTON_NO_ESYNC 1
set -gx PROTON_NO_FSYNC 1
set -gx PROTON_USE_NTSYNC 1
set -gx PROTON_USE_WOW64 1
set -gx PROTON_ENABLE_WAYLAND 1

# GPG
if status is-interactive
    set -gx GPG_TTY (tty)
end

# PATH additions (fish_add_path is idempotent and checks for duplicates)
fish_add_path ~/.local/bin
fish_add_path /opt/local/bin
fish_add_path /opt/local/libexec/gnubin
fish_add_path /opt/homebrew/bin

# Go
if test -d "$HOME/gowork"
    set -gx GOPATH "$HOME/gowork"
    set -gx GOBIN "$GOPATH/bin"
    fish_add_path $GOBIN
end

# Rust
fish_add_path ~/.cargo/bin

set -gx MAVEN_OPTS "-Xmx2g"
