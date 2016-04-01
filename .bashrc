#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="/home/ismael/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bobby'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

# your own settings

# check if terminal supports colors
# if [ “$TERM” != “dumb” ]; then
#   eval "`dircolors -b`"
#   alias ls='ls --color=auto'
# fi

# Script for ensuring only one instance of gpg-agent is running
# and if there is not one, start an instance of gpg-agent.
# if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
#      GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info`
#      SSH_AUTH_SOCK=`cat $HOME/.ssh-auth-sock`
#      SSH_AGENT_PID=`cat $HOME/.ssh-agent-pid`
#      export GPG_AGENT_INFO SSH_AUTH_SOCK SSH_AGENT_PID
# else
#      eval `gpg-agent --daemon`
#      echo $GPG_AGENT_INFO >$HOME/.gpg-agent-info
#      echo $SSH_AUTH_SOCK > $HOME/.ssh-auth-sock
#      echo $SSH_AGENT_PID > $HOME/.ssh-agent-pid
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

