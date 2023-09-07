export TZ=Europe/Paris
export TERM=xterm-256color
export SVN_EDITOR=vim
export EDITOR=vim
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS='-C -M -I -j 10 -# 4 -R'
export PAGER=less

# added the /usr/local/bin
export PATH=/usr/local/bin:$PATH
# added macports path
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# added gnu path as default
export PATH=/opt/local/libexec/gnubin:$PATH

# home binaries directory
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# homebrew binaries directory
if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# homebrew anaconda
#if [ -d "/opt/homebrew/bin" ]; then
    #export PATH="/opt/homebrew/anaconda3/bin:$PATH"
#fi

# load asdf
if [ -d "$HOME/.asdf" ]; then
    source $HOME/.asdf/asdf.sh
fi

# load sdkman ressources if available
if [ -d "$HOME/.sdkman" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"

# hadoop path
if [ -d "$HOME/jprograms/hadoop" ]; then
    export HADOOP_HOME="$HOME/jprograms/hadoop"
    export PATH=$HADOOP_HOME/bin:$PATH
fi

# protobuf path
#if [ -d "$HOME/jprograms/protoc" ]; then
    #export PROTOC_HOME="$HOME/jprograms/protoc"
    #export PATH=$PROTOC_HOME/bin:$PATH
#fi

# golang
if [ -d "$HOME/gowork" ]; then
    export GOPATH=$HOME/gowork
    export GOBIN=$GOPATH/bin
    export PATH=$GOBIN:$PATH
fi

# haskell cabal path
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi
#
# .net path
if [ -d "$HOME/.dotnet/tools" ]; then
    PATH="$HOME/.dotnet/tools:$PATH"
fi

# node.js
export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"
export PATH="$HOME/.node/bin:$PATH"
export MANPATH="$HOME/.node/share/man:$MANPATH"

# yarn
if [ -f "/usr/bin/yarn" ]; then
    export PATH="$PATH:`/usr/bin/yarn global bin --offline`"
fi

# deno
if [ -d "$HOME/.deno" ]; then
    DENO_INSTALL="$HOME/.deno"
    PATH="$DENO_INSTALL/bin:$PATH"
fi

# ruby
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# cuda
#export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
#export PATH=/usr/local/cuda/bin:$PATH

# rust
#. "$HOME/.cargo/env"
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# base16-shell
if [ -d "$HOME/.config/base16-shell" ]; then
    export BASE16_SHELL=$HOME/.config/base16-shell/
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

# alias for remote irssi
alias rirssi='ssh -Y vividores -t .irssi/screen'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ls='ls -GF --color=always'
alias ll='ls -lF'
alias la='ls -alF'
alias x='exit'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v='vim'
alias vi='vim'
alias vit='vim.tiny -u NONE'

# some missing git alias
alias gau='git add -u'
alias gcd='cd $(git rev-parse --show-cdup)'
alias gdc='git diff --cached'
alias gwl='git worktree list'
alias gwp='git worktree prune'

# interactive aliases, need fxf
# git add interactive
alias gai='git add $(git diff --name-only | fzf --multi | tr "\n" " ")'
# git reset file interactive
alias gui='git reset $(git diff --name-only | fzf --multi | tr "\n" " ")'
# git reset HEAD file interactive (unstage file)
alias guci='git reset HEAD $(git diff --name-only --cached | fzf --multi | tr "\n" " ")'
# git switch branch interactive
alias gsb='git checkout $(git branch | fzf)'
# git switch branch all interactive
alias gsba='git checkout -t $(git branch -a | fzf)'
# git find interactive
alias gfi='git show $(git log --pretty=oneline | fzf | cut -d=" " -f1)'
# checkout pr
alias ghco='gh pr checkout $(gh pr list -L 300 | fzf --multi | awk '"'"'{print $1}'"'"')'

alias ip='ip --color'
alias ipb='ip --color --brief'
alias scd='cd $(svn info . | grep -F "Working Copy Root Path:" | cut -c25-)'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

# alias use threads by default
alias qmvn='mvn --threads 1C --offline'

# modern utils configuration
export BAT_THEME="DarkNeon"

GPG_TTY=$(tty)
export GPG_TTY

# wayland
#export MOZ_ENABLE_WAYLAND=1

unalias mvnd

