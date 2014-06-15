export CLICOLOR=1
# export LS_COLORS='di=01;33'
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export LSCOLORS="exfxcxdxbxegedabagacad"

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
fi
export PATH=$JAVA_HOME/bin:$PATH

# go path
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
# temp fix to use the dev version of go
export PATH=~/projects/go/bin:$PATH

# haskell cabal path
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

# cuda
#export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH

# python pip configuration
#export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/3.4/bin:$PATH
export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH
# virtualenv config
if [ -f /opt/local/bin/virtualenvwrapper.sh-2.7 ]; then
    export WORKON_HOME=~/.virtualenvs
    export VIRTUALENVWRAPPER_VIRTUALENV=/opt/local/bin/virtualenv-2.7
    source /opt/local/bin/virtualenvwrapper.sh-2.7
fi

# node modules binary path
export PATH=~/node_modules/.bin:$PATH

# this should be in .bashrc but to do this we have to create
# the .bash_profile file with
# . ~/.profile
# . ~/.bashrc
#

# bash completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

# bash completion - ant
# complete -C /opt/local/share/java/apache-ant/bin/complete-ant-cmd.pl ant
# bash completion - git
# export PS1='\h:\W$(__git_ps1 "(%s)") \u\$ '
# export GIT_PS1_SHOWDIRTYSTATE=1 #... untagged(*) and staged(+) changes
# export GIT_PS1_SHOWSTASHSTATE=1 #... if something is stashed($)
# export GIT_PS1_SHOWUNTRACKEDFILES=1 #... untracked files(%)

# export USER_BASH_COMPLETION_DIR=~/.bash_completion.d

# Increase the number of commands recorded
export HISTSIZE=100000
export HISTFILESIZE=100000
# Add datestamps
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# ignore commands from history
export HISTIGNORE="&:ls:[bf]g:exit"
# Avoid succesive duplicates in the bash command history.
export HISTCONTROL=ignoredups
# Append versus overwrite and write more often to handle multiple
# sessions eventuall -r
# shopt -s histappend
export PROMPT_COMMAND='history -n;history -a'
# Handle multiple line commands
# shopt -s cmdhist

# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# this should be in .bash_aliases

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

# alias for git
alias g='git'

# alias for octave
if [ -f /usr/local/octave/3.8.0/bin/octave ]; then
    alias octave='/usr/local/octave/3.8.0/bin/octave'
fi

# show git branch
#source ~/.git-completion.bash
#source ~/.git-prompt.sh

PS1='\h:\w\[\033[32m\]$(__git_ps1) \[\033[0m\]$ '
# export PS1="\u@\h \w> "

# Case insensitive tab completion in Bash
# bind "set completion-ignore-case on"
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# set show-all-if-ambiguous on

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

# docker export
export DOCKER_HOST=tcp://localhost:4243

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

