# Contains my general environment variables and PATH setup
# Try to keep it minimal
# Aliases and functions live in ~/.bash_aliases

export TZ=Europe/Paris

export TERM=xterm-256color
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

export PROTON_NO_ESYNC=1
export PROTON_NO_FSYNC=1
export PROTON_USE_NTSYNC=1
export PROTON_USE_WOW64=1
export PROTON_ENABLE_WAYLAND=1

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

# golang
if [ -d "$HOME/gowork" ]; then
    export GOPATH="$HOME/gowork"
    export GOBIN="$GOPATH/bin"
    PATH="$GOBIN:$PATH"
fi

# rust
if [ -d "$HOME/.cargo/bin" ]; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

export MAVEN_OPTS="-Xmx2g"
#export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"

