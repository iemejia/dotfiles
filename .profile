export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad
export TERM=xterm-256color

# MacPorts Installer addition on 2010-01-16_at_02:45:27: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
# export JAVA_HOME=/Library/Java/Home
export JAVA_HOME=`/usr/libexec/java_home`
export SVN_EDITOR=emacs
export EDITOR=emacs

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

# alias for mysql
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

##
# Your previous /Users/ismael/.profile file was backed up as /Users/ismael/.profile.macports-saved_2011-11-17_at_00:35:03
##

# MacPorts Installer addition on 2011-11-17_at_00:35:03: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


##
# Your previous /Users/ismael/.profile file was backed up as /Users/ismael/.profile.macports-saved_2012-02-28_at_08:41:07
##

# MacPorts Installer addition on 2012-02-28_at_08:41:07: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# cuda
export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH
