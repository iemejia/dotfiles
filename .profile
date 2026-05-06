# Contains my general enverionment variables and alias
# Try to keep it minimal

HISTSIZE=50000
HISTFILESIZE=100000

export TZ=Europe/Paris

export TERM=xterm-256color
export GIT_EDITOR=vim
export SVN_EDITOR=vim
export IRC_CLIENT='irssi'

export EDITOR=vim
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS='-C -M -I -j 10 -# 4 -R'
export PAGER=less

# Be sure everything we type is UTF-8
export LC_CTYPE=en_US.UTF-8
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

export GPG_TTY
GPG_TTY=$(tty)

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias x='exit'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v='vim'
alias vi='vim'
alias vit='vim.tiny -u NONE'
alias n='nvim'

# TODO alias for remote irssi
alias rirssi='ssh -Y vividores -t .irssi/screen'

alias scd='cd $(svn info . | grep -F "Working Copy Root Path:" | cut -c25-)'

# git aliases
alias g='git'
alias gap='git add -p'
alias gau='git add -u'
alias gca='git commit --amend'
alias gcd='cd $(git rev-parse --show-cdup)'
alias gd='git diff'
alias gdc='git diff --cached'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gst='git status'
alias gwl='git worktree list'
alias gwp='git worktree prune'

# interactive aliases use fxf
# git add interactive
alias gai='git add $(git diff --name-only | fzf --multi | tr "\n" " ")'
# git reset file interactive
alias gui='git reset $(git diff --name-only | fzf --multi | tr "\n" " ")'
# git reset HEAD file interactive (unstage file)
alias guci='git reset HEAD $(git diff --name-only --cached | fzf --multi | tr "\n" " ")'
# git switch branch interactive
alias gsb='git switch $(git branch | fzf)'
# git switch branch all interactive
alias gsba='git switch -t $(git branch -a | fzf)'
# git find interactive
alias gfi='git show $(git log --pretty=oneline | fzf | cut -d=" " -f1)'

# checkout pr
ghco() {
    gh pr list -L 300 | fzf --multi | awk '{print $1}' | while IFS= read -r pr; do
    gh pr checkout "$pr"
    done
}

alias gitls="git ls-files --sparse --full-name -z | \
  xargs -0 -I FILE -P 20 git log --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | \
  sort --general-numeric-sort"

alias gitls1="git ls-files --sparse --full-name -z | \
  xargs -0 -I FILE -P 20 git log -1 --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | \
  sort --general-numeric-sort"



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
    export PATH="/opt/homebrew/bin:$PATH"
fi


# golang
if [ -d "$HOME/gowork" ]; then
    export GOPATH="$HOME/gowork"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"
fi

# rust
#. "$HOME/.cargo/env"
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

#!/usr/bin/env bash
export MAVEN_OPTS="-Xmx2g"
#export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi

