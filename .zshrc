# enable to profile zsh
# zmodload zsh/zprof

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
DISABLE_AUTO_UPDATE="true"

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
plugins=(
    # ant
    # autopep8
    aws
    # bower
    # bundler
    # cabal
    cargo
    cp
    docker-compose
    docker
    fzf
    # gem
    git
    github
    gnu-utils
    golang
    gradle
    # grunt
    # gulp
    # helm
    history
    # jira
    # kops
    kubectl
    # lein
    # macports
    # mercurial
    # minikube
    # mosh
    mvn
    # mysql
    node
    npm
    # osx
    # pep8
    pip
    # postgres
    pylint
    python
    # rails
    # rake
    # redis-cli
    rsync
    # ruby
    rust
    sbt
    scala
    # screen
    # ssh-agent
    # stack
    # sudo
    # supervisor
    svn
    systemd
    # terraform
    tmux
    # ubuntu
    # vault
    # vagrant
    # virtualenv
    yarn
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# Customize to your needs...

# improve history search
bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward
# bindkey -s '\eOA' '\e[A'
# extra codes for the mapping in ubuntu linux
bindkey '\O[A' history-beginning-search-backward
bindkey '\O[B' history-beginning-search-forward

# Fix C-u like in bash
bindkey \^U backward-kill-line

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

# powerline support
if [[ -r ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi

# OPAM configuration
#@. /home/ismael/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
#eval `opam config env`

if [ -d "$GOOGLE_SDK_HOME" ]; then
    # The next line updates PATH for the Google Cloud SDK.
    source "$GOOGLE_SDK_HOME/path.zsh.inc"
    # The next line enables shell command completion for gcloud.
    source "$GOOGLE_SDK_HOME/completion.zsh.inc"
fi

source "$HOME/.profile"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# enable to profile zsh
# zprof
