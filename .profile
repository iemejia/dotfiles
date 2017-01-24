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
    export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1"
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

# leiningen path
if [ -d "$HOME/jprograms/leiningen" ]; then
    export LEIN_HOME="$HOME/jprograms/leiningen"
    export PATH=$LEIN_HOME/bin:$PATH
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
if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    source ~/.local/bin/virtualenvwrapper.sh
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

# some missing git alias
alias gau='git add -u'
alias gdc='git diff --cached'
alias gwl='git worktree list'
alias gwp='git worktree prune'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

