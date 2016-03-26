alias ls='ls -GF --color=always --human-readable'

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# This is like replying yes and automatically update
DISABLE_UPDATE_PROMPT="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(cp git github mysql python vagrant mercurial macports golang scala sbt go ruby gem svn osx rails tmux systemd aws bower cabal docker gradle mvn grunt gulp node npm pip pylint python scala sbt)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export TZ=Europe/Paris
export TERM=xterm-256color
export SVN_EDITOR=vim
export EDITOR=vim

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

# java path
if [ -d /usr/lib/jvm/default-java ]; then
    export JAVA_HOME='/usr/lib/jvm/default-java'
    export PATH=$JAVA_HOME/bin:$PATH
fi

# maven path
if [ -d "$HOME/jprograms/maven" ]; then
    export MAVEN_HOME="$HOME/jprograms/maven"
    export PATH=$MAVEN_HOME/bin:$PATH
fi

# gradle path
if [ -d "$HOME/jprograms/gradle" ]; then
    export GRADLE_HOME="$HOME/jprograms/gradle"
    export PATH=$GRADLE_HOME/bin:$PATH
fi

# hadoop path
if [ -d "$HOME/jprograms/hadoop" ]; then
    export HADOOP_HOME="$HOME/jprograms/hadoop"
    export PATH=$HADOOP_HOME/bin:$PATH
fi

# golang-go local path if available
if [ -d "$HOME/go" ]; then
    export GOROOT=$HOME/go
    export PATH=$GOROOT/bin:$PATH
fi
export GOPATH=$HOME/gowork

# haskell cabal path
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

# node.js
export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"
export PATH="$HOME/.node/bin:$PATH"
export MANPATH="$HOME/.node/share/man:$MANPATH"

# ruby
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# cuda
#export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH

# python pip configuration
#export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH
#export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH
# virtualenv config
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME=~/.virtualenvs
    # export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv-2.7
    source /usr/local/bin/virtualenvwrapper.sh
fi

# alias for remote irssi
alias rirssi='ssh -Y iemejia@wezen.dreamhost.com -t .irssi/screen'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ls='ls -GF --color=always --human-readable'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v='vim'
alias vi='vim'
alias vit='vim.tiny -u NONE'

# alias for git
alias g='git'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# improve history search
bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward
# bindkey -s '\eOA' '\e[A'
# extra codes for the mapping in ubuntu linux
bindkey '\O[A' history-beginning-search-backward
bindkey '\O[B' history-beginning-search-forward

# use vi-mode
# bindkey -v
# bindkey '^P' up-history
# bindkey '^N' down-history
# bindkey '^?' backward-delete-char
# bindkey '^h' backward-delete-char
# bindkey '^w' backward-kill-word
# bindkey '^r' history-incremental-search-backward
#
# function zle-line-init zle-keymap-select {
#     VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
#     RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$(git_custom_status) $EPS1"
#     zle reset-prompt
# }
#
# zle -N zle-line-init
# zle -N zle-keymap-select
#export KEYTIMEOUT=1
#

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

# powerline support
if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi


# ssh-agent
if ! pgrep ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

