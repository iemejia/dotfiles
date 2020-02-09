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
    # gradle
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
    sdk
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

source "$HOME/.profile"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"  # This loads wasmer

# Use ripgrep
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Gradle completion
fpath=($HOME/.gradle-completion $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

prompt_svn() {
    local rev branch
    if in_svn; then
        rev=$(svn_get_rev_nr)
        branch=$(svn_get_branch_name)
        if [ `svn_dirty_choose_pwd 1 0` -eq 1 ]; then
            prompt_segment yellow black
            echo -n "$rev@$branch"
            echo -n "±"
        else
            prompt_segment green black
            echo -n "$rev@$branch"
        fi
    fi
}

build_prompt() {
    RETVAL=$?
    prompt_status
    prompt_context
    prompt_dir
    prompt_git
    prompt_svn
    prompt_end
}

# enable to profile zsh
# zprof


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

