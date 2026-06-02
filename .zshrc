# Profile zsh startup: uncomment both zmodload and zprof lines
# zmodload zsh/zprof

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(
    aws
    cp
    docker-compose
    docker
    dotenv
    fzf
    git
    golang
    history
    kubectl
    mvn
    node
    npm
    pip
    python
    rsync
    rust
    terraform
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# History search with arrow keys
bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward
bindkey '\O[A' history-beginning-search-backward
bindkey '\O[B' history-beginning-search-forward

# Fix C-u like in bash
bindkey \^U backward-kill-line

source "$HOME/.profile"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Bash completions compatibility
autoload bashcompinit
bashcompinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

[ -f /opt/homebrew/etc/bash_completion.d/az ] && source /opt/homebrew/etc/bash_completion.d/az

# Airflow Breeze autocomplete
[ -f ~/apache/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh ] && \
    source ~/apache/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh

export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"

# >>> conda initialize >>>
if [ -d "$HOME/mambaforge" ]; then
    __conda_setup="$("$HOME/mambaforge/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/mambaforge/etc/profile.d/conda.sh" ]; then
            . "$HOME/mambaforge/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/mambaforge/bin:$PATH"
        fi
    fi
    unset __conda_setup
    [ -f "$HOME/mambaforge/etc/profile.d/mamba.sh" ] && . "$HOME/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

if [ -d "/opt/homebrew/opt/fzf" ]; then
    export FZF_BASE=/opt/homebrew/opt/fzf/install
fi

# >>> mamba initialize >>>
if [ -x "$HOME/mambaforge/bin/mamba" ]; then
    export MAMBA_EXE="$HOME/mambaforge/bin/mamba"
    export MAMBA_ROOT_PREFIX="$HOME/mambaforge"
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias mamba="$MAMBA_EXE"
    fi
    unset __mamba_setup
fi
# <<< mamba initialize <<<

# zprof
