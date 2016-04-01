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
alias ll='ls -lF'
alias la='ls -alF'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v='vim'
alias vi='vim'
alias vit='vim.tiny -u NONE'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# check if terminal supports colors
# if [ “$TERM” != “dumb” ]; then
#   eval "`dircolors -b`"
#   alias ls='ls --color=auto'
# fi

# Script for ensuring only one instance of gpg-agent is running
# and if there is not one, start an instance of gpg-agent.
# if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
# 	GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
# 	SSH_AUTH_SOCK=`cat $HOME/.ssh-auth-sock`
# 	SSH_AGENT_PID=`cat $HOME/.ssh-agent-pid`
# 	export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
# else
# 	eval `gpg-agent --daemon`
# 	echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
# 	echo $SSH_AUTH_SOCK > $HOME/.ssh-auth-sock
# 	echo $SSH_AGENT_PID > $HOME/.ssh-agent-pid
# fi
# Imperative that this environment variable always reflects the output
# of the tty command.
export GPG_TTY=`tty`

# configuration for powerline in bash
#if [ -f $HOME/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh ]; then
#    source $HOME/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
#fi

# vi-mode
#set -o vi

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

