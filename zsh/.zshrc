# Profile zsh startup: uncomment both zmodload and zprof lines
# zmodload zsh/zprof

ZSH=$HOME/.oh-my-zsh
# Use starship prompt if available, otherwise fall back to agnoster
if command -v starship &>/dev/null; then
    ZSH_THEME=""
else
    ZSH_THEME="agnoster"
fi
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"
ZSH_DISABLE_COMPFIX="true"  # skip compaudit security check (~60ms)

# Set FZF_BASE before oh-my-zsh so the fzf plugin finds it without searching
if [ -d "/opt/homebrew/opt/fzf" ]; then
    export FZF_BASE=/opt/homebrew/opt/fzf
fi

# Add Homebrew completions to FPATH before oh-my-zsh runs compinit
if [[ -d "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" ]]; then
    FPATH="${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions:${FPATH}"
fi

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

# open file in vi via fzf
vf() {
    local file
    file=$(fzf --height=40% --reverse) || return
    vi "$file"
}

# History search with arrow keys
bindkey '\eOA' history-beginning-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\eOB' history-beginning-search-forward
bindkey '\e[B' history-beginning-search-forward
bindkey '\O[A' history-beginning-search-backward
bindkey '\O[B' history-beginning-search-forward

# Fix C-u like in bash
bindkey \^U backward-kill-line

# Source .profile only if not already loaded (login shells source it via .zprofile)
if [[ -z "$_PROFILE_LOADED" ]]; then
    source "$HOME/.profile"
fi

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Azure CLI (az) completion (needs bashcompinit for bash-style 'complete')
if [ -f /opt/homebrew/etc/bash_completion.d/az ]; then
    (( $+functions[bashcompinit] )) || { autoload bashcompinit && bashcompinit }
    source /opt/homebrew/etc/bash_completion.d/az
fi

# Fabio completion (cached to avoid forking on every startup)
if command -v fabio &>/dev/null; then
    _fabio_comp="${XDG_CACHE_HOME:-$HOME/.cache}/fabio-completions.zsh"
    if [ ! -f "$_fabio_comp" ]; then
        mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}"
        fabio completions zsh > "$_fabio_comp"
    fi
    source "$_fabio_comp"
    unset _fabio_comp
fi

# Hugging Face CLI completion
if command -v hf &>/dev/null; then
    _hf_completion() {
        eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _HF_COMPLETE=complete_zsh hf)
    }
    compdef _hf_completion hf
fi

# Airflow Breeze autocomplete
[ -f ~/apache/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh ] && \
    source ~/apache/airflow/dev/breeze/autocomplete/breeze-complete-zsh.sh

[ -d "/usr/local/opt/libpq/bin" ] && export PATH="/usr/local/opt/libpq/bin:$PATH"
[ -d "$HOME/.dotnet/tools" ] && export PATH="$HOME/.dotnet/tools:$PATH"

# >>> conda/mamba initialize (lazy-loaded) >>>
if [ -d "$HOME/mambaforge" ]; then
    conda() {
        unset -f conda mamba 2>/dev/null
        __conda_setup="$("$HOME/mambaforge/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
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
        if [ -x "$HOME/mambaforge/bin/mamba" ]; then
            export MAMBA_EXE="$HOME/mambaforge/bin/mamba"
            export MAMBA_ROOT_PREFIX="$HOME/mambaforge"
            __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
            [ $? -eq 0 ] && eval "$__mamba_setup"
            unset __mamba_setup
        fi
        conda "$@"
    }
    mamba() { conda; mamba "$@"; }
fi
# <<< conda/mamba initialize <<<

# Starship prompt
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# zprof
