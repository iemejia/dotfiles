export CLICOLOR=1
# export LS_COLORS='di=01;33'
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
export LSCOLORS="exfxcxdxbxegedabagacad"

export TERM=xterm-256color
export SVN_EDITOR=vim
export EDITOR=vim

# MacPorts Installer addition on 2010-01-16_at_02:45:27: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# Finished adapting your PATH environment variable for use with MacPorts.
if [ -f /usr/libexec/java_home ]; then
    export JAVA_HOME=`/usr/libexec/java_home`
fi

export GOPATH=$HOME/go

# MacPorts Installer addition on 2012-02-28_at_08:41:07: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH:$GOPATH/bin
# Finished adapting your PATH environment variable for use with MacPorts.

# cuda
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH

# python 2.7
export PATH=/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

# temporary camlistore path
export PATH=~/projects/camlistore/bin:$PATH

#
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
complete -C /opt/local/share/java/apache-ant/bin/complete-ant-cmd.pl ant
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
shopt -s histappend
export PROMPT_COMMAND='history -n;history -a'
# Handle multiple line commands
shopt -s cmdhist

# Add bash aliases.
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# this should be in .bash_aliases

# alias for mysql
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# Make some possibly destructive commands more interactive.
# alias rm='rm -i'
# alias mv='mv -i'
# alias cp='cp -i'
 
# use gnu ls if available (hacky solution to the color problem)
if [ -x /usr/local/bin/gls ]; then
    alias ls='/usr/local/bin/gls -GF --color --human-readable'
else
    alias ls='ls -GF --color --human-readable'
fi

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ll='ls -lF'
alias la='ls -alF'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
 
# show git branch
source ~/.git-completion.bash
source ~/.git-prompt.sh

PS1='\h:\w\[\033[32m\]$(__git_ps1) \[\033[0m\]$ '

# Case insensitive tab completion in Bash
bind "set completion-ignore-case on"
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# set show-all-if-ambiguous on

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Personal ones
alias catho="~/repositories/catho/catho/catho.py"
alias subl="'/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl'"
alias youtube-dl="~/projects/youtube-dl/youtube-dl"
alias coursera-dl="~/projects/coursera/coursera-dl"

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

