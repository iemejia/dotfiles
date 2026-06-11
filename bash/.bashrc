# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=50000
HISTFILESIZE=100000

# Share history across all tmux panes/windows in real time
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls via dircolors
if command -v dircolors >/dev/null 2>&1; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias and function definitions live in ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /opt/homebrew/share/bash-completion/bash_completion ]; then
    . /opt/homebrew/share/bash-completion/bash_completion
  elif [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
    . /usr/local/etc/profile.d/bash_completion.sh
  fi
  # User completion scripts (stow-managed)
  if [ -d ~/.bash_completion.d ]; then
    for f in ~/.bash_completion.d/*; do
      [ -f "$f" ] && . "$f"
    done
  fi
fi

# nvm (lazy-loaded: ~3s startup cost deferred until first use)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _nvm_lazy_load() {
        unset -f nvm node npm npx corepack
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }
    nvm()      { _nvm_lazy_load; nvm "$@"; }
    node()     { _nvm_lazy_load; node "$@"; }
    npm()      { _nvm_lazy_load; npm "$@"; }
    npx()      { _nvm_lazy_load; npx "$@"; }
    corepack() { _nvm_lazy_load; corepack "$@"; }
fi

# fzf completion and key-bindings (cached)
if command -v fzf &>/dev/null; then
    _fzf_comp="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completions/fzf.bash"
    if [ ! -f "$_fzf_comp" ] || [ "$(command -v fzf)" -nt "$_fzf_comp" ]; then
        mkdir -p "${_fzf_comp%/*}"
        fzf --bash > "$_fzf_comp" 2>/dev/null
    fi
    . "$_fzf_comp"
    unset _fzf_comp
fi

# Load git completion eagerly (must be after fzf to prevent fzf from
# overriding it with path completion due to lazy-loading race condition)
if [ -f /usr/share/bash-completion/completions/git ]; then
    . /usr/share/bash-completion/completions/git
elif [ -f /opt/homebrew/share/bash-completion/completions/git ]; then
    . /opt/homebrew/share/bash-completion/completions/git
elif [ -f /usr/local/share/bash-completion/completions/git ]; then
    . /usr/local/share/bash-completion/completions/git
fi
# Completion wrappers for git aliases (br=branch, co=checkout, etc.)
_git_br() { _git_branch "$@"; }
_git_co() { _git_checkout "$@"; }
_git_ci() { _git_commit "$@"; }
_git_ca() { _git_commit "$@"; }
_git_cm() { _git_commit "$@"; }
_git_df() { _git_diff "$@"; }
_git_d() { _git_diff "$@"; }
_git_dc() { _git_diff "$@"; }
_git_a() { _git_add "$@"; }
_git_ai() { _git_add "$@"; }
_git_ap() { _git_add "$@"; }
# Enable completion for the 'g' shell alias
if type __git_complete &>/dev/null; then
    __git_complete g __git_main
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# OpenClaw Completion
[ -f "$HOME/.openclaw/completions/openclaw.bash" ] && source "$HOME/.openclaw/completions/openclaw.bash"

# Azure CLI (az) completion
if [ -f /opt/homebrew/etc/bash_completion.d/az ]; then
    source /opt/homebrew/etc/bash_completion.d/az
elif [ -f /etc/bash_completion.d/azure-cli ]; then
    source /etc/bash_completion.d/azure-cli
fi

# Azure Developer CLI (azd) completion (cached)
if command -v azd &>/dev/null; then
    _azd_comp="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completions/azd.bash"
    if [ ! -f "$_azd_comp" ] || [ "$(command -v azd)" -nt "$_azd_comp" ]; then
        mkdir -p "${_azd_comp%/*}"
        azd completion bash > "$_azd_comp" 2>/dev/null
    fi
    . "$_azd_comp"
    unset _azd_comp
fi

# GitHub CLI (gh) completion (cached)
if command -v gh &>/dev/null; then
    _gh_comp="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completions/gh.bash"
    if [ ! -f "$_gh_comp" ] || [ "$(command -v gh)" -nt "$_gh_comp" ]; then
        mkdir -p "${_gh_comp%/*}"
        gh completion -s bash > "$_gh_comp" 2>/dev/null
    fi
    . "$_gh_comp"
    unset _gh_comp
fi

# Fabio completion (cached)
if command -v fabio &>/dev/null; then
    _fabio_comp="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completions/fabio.bash"
    if [ ! -f "$_fabio_comp" ] || [ "$(command -v fabio)" -nt "$_fabio_comp" ]; then
        mkdir -p "${_fabio_comp%/*}"
        fabio completions bash > "$_fabio_comp" 2>/dev/null
    fi
    . "$_fabio_comp"
    unset _fabio_comp
fi

# kubectl completion (cached)
if command -v kubectl &>/dev/null; then
    _kubectl_comp="${XDG_CACHE_HOME:-$HOME/.cache}/bash-completions/kubectl.bash"
    if [ ! -f "$_kubectl_comp" ] || [ "$(command -v kubectl)" -nt "$_kubectl_comp" ]; then
        mkdir -p "${_kubectl_comp%/*}"
        kubectl completion bash > "$_kubectl_comp" 2>/dev/null
    fi
    . "$_kubectl_comp"
    # Also complete the common 'k' alias
    complete -o default -F __start_kubectl k
    unset _kubectl_comp
fi

# Hugging Face CLI completion
if command -v hf &>/dev/null; then
    _hf_completion() {
        local IFS=$'\n'
        COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                       COMP_CWORD=$COMP_CWORD \
                       _HF_COMPLETE=complete_bash $1 ) )
        return 0
    }
    complete -o default -F _hf_completion hf
fi
