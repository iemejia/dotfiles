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

# java path
if [ -d /usr/lib/jvm/default-java ]; then
    export JAVA_HOME='/usr/lib/jvm/default-java'
    export JDK_HOME=$JAVA_HOME
    export PATH=$JAVA_HOME/bin:$PATH
fi

# ant path
if [ -d "$HOME/jprograms/ant" ]; then
    export ANT_HOME="$HOME/jprograms/ant"
    export PATH=$ANT_HOME/bin:$PATH
fi

# maven path
if [ -d "$HOME/jprograms/maven" ]; then
    export MAVEN_HOME="$HOME/jprograms/maven"
    export MAVEN_OPTS="-client -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Xverify:none"
    export PATH=$MAVEN_HOME/bin:$PATH
fi

# hadoop path
if [ -d "$HOME/jprograms/hadoop" ]; then
    export HADOOP_HOME="$HOME/jprograms/hadoop"
    export PATH=$HADOOP_HOME/bin:$PATH
fi

# protobuf path
if [ -d "$HOME/jprograms/protoc" ]; then
    export PROTOC_HOME="$HOME/jprograms/protoc"
    export PATH=$PROTOC_HOME/bin:$PATH
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

if [ -d "$HOME/gowork" ]; then
    export GOPATH=$HOME/gowork
    export GOBIN=$GOPATH/bin
    export PATH=$GOBIN:$PATH
fi

# haskell cabal path
if [ -d "$HOME/.cabal/bin" ]; then
    PATH="$HOME/.cabal/bin:$PATH"
fi

# node.js
export NODE_PATH="$HOME/.node/lib/node_modules:$NODE_PATH"
export PATH="$HOME/.node/bin:$PATH"
export MANPATH="$HOME/.node/share/man:$MANPATH"

# yarn
if [ -f "/usr/bin/yarn" ]; then
    export PATH="$PATH:`/usr/bin/yarn global bin`"
fi

# ruby
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# cuda
#export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin:$PATH

# rust
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# GOOGLE_SDK_HOME
if [ -d "$HOME/jprograms/google-cloud-sdk" ]; then
    export GOOGLE_SDK_HOME=~/jprograms/google-cloud-sdk
    export PATH="$GOOGLE_SDK_HOME/bin:$PATH"
fi

# base16-shell
if [ -d "$HOME/.config/base16-shell" ]; then
    export BASE16_SHELL=$HOME/.config/base16-shell/
    [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

# alias for remote irssi
alias rirssi='ssh -Y vividores -t .irssi/screen'

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ls='ls -GF --color=always --human-readable'
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
# git find interactive
alias gfi='git show $(git log --pretty=oneline | fzf | cut -d=" " -f1)'


alias ip='ip --color'
alias ipb='ip --color --brief'

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# TV aliases
alias caracol="livestreamer \"hds://http://acaooyalahd2-lh.akamaihd.net/z/caracol01_delivery@187698/manifest.f4m?hdcore=2.10.3&g=PEWEWKTRRUJM\" best"
alias rcn="livestreamer \"hds://http://ooyalahd2-f.akamaihd.net/z/saleslatam_test06@180219/manifest.f4m?hdcore=2.10.3&g=PEKPFNBGBTUV\" best"

# alias use threads by default
alias qmvn='mvn --threads 1C --offline'

