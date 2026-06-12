# Contains my general environment variables and PATH setup
# Try to keep it minimal
# Aliases and functions live in ~/.bash_aliases

# Guard against being sourced twice (e.g. .zprofile + .zshrc)
[ -n "$_PROFILE_LOADED" ] && return
_PROFILE_LOADED=1

export TZ=Europe/Paris

# Use the terminal's TERM if its terminfo is available, otherwise fall back
if [ -n "$TERM" ] && infocmp "$TERM" >/dev/null 2>&1; then
    : # keep current TERM (e.g. xterm-ghostty)
else
    export TERM=xterm-256color
fi
export GIT_EDITOR=vim
export SVN_EDITOR=vim
export IRC_CLIENT='irssi'

export EDITOR=vim
if [ -f /usr/share/source-highlight/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
elif [ -f /opt/homebrew/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /opt/homebrew/bin/src-hilite-lesspipe.sh %s"
elif [ -f /usr/local/bin/src-hilite-lesspipe.sh ]; then
    export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
fi
export LESS='-C -M -I -j 10 -# 4 -R'
export PAGER=less

# Be sure everything we type is UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export DO_NOT_TRACK=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export SAM_CLI_TELEMETRY=0
export AZURE_CORE_COLLECT_TELEMETRY=0
export HOMEBREW_NO_ANALYTICS=1

export FORCE_COLOR=1

# fzf: Ctrl-O inside Ctrl-T picker opens selection in vi
export FZF_CTRL_T_OPTS="--bind 'ctrl-o:execute(vi {})+abort'"

# Linux gaming (Steam Proton)
if [ "$(uname)" = "Linux" ]; then
    export PROTON_NO_ESYNC=1
    export PROTON_NO_FSYNC=1
    export PROTON_USE_NTSYNC=1
    export PROTON_USE_WOW64=1
    export PROTON_ENABLE_WAYLAND=1
fi

if [ -t 0 ]; then
    GPG_TTY=$(tty)
    export GPG_TTY
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/opt/local/bin" ]; then
    PATH="/opt/local/bin:$PATH"
fi

if [ -d "/opt/local/libexec/gnubin" ]; then
    PATH="/opt/local/libexec/gnubin:$PATH"
fi

if [ -d "/opt/homebrew/bin" ]; then
    PATH="/opt/homebrew/bin:$PATH"
fi

if [ -d "$HOME/gowork" ]; then
    export GOPATH="$HOME/gowork"
    export GOBIN="$GOPATH/bin"
    PATH="$GOBIN:$PATH"
fi
# Add default GOPATH/bin for go-installed binaries
[ -d "$HOME/go/bin" ] && PATH="$PATH:$HOME/go/bin"

if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# uv-managed Python (latest installed version)
if [ -d "$HOME/.local/share/uv/python" ]; then
    _uv_py_bin=""
    for _d in "$HOME/.local/share/uv/python"/cpython-*/bin; do
        [ -d "$_d" ] && _uv_py_bin="$_d"
    done
    [ -n "$_uv_py_bin" ] && PATH="$_uv_py_bin:$PATH"
    unset _d _uv_py_bin
fi

if [ -d "$HOME/.local/share/coursier/bin" ]; then
    PATH="$HOME/.local/share/coursier/bin:$PATH"
fi

export MAVEN_OPTS="-Xmx2g"
#export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"

if [ -d "$HOME/.pgenv/" ]; then
    PATH="$HOME/.pgenv/bin:$HOME/.pgenv/pgsql/bin:$PATH"
fi

# Enable opencode notification sound only on machines with audio
if [ -d /proc/asound ] || command -v pactl > /dev/null 2>&1; then
    export OPENCODE_SOUND=true
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
