# Custom aliases and functions
# Sourced by ~/.bashrc for all interactive shells

# Add some easy shortcuts for formatted directory listings and add a touch of color.
if ls --color=auto / >/dev/null 2>&1; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep='grep --color=auto' # --exclude-dir=\.svn'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Quick exit
alias x='exit'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if command -v notify-send >/dev/null 2>&1; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
else
    alias alert='osascript -e "display notification \"$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')\""'
fi

# Editors
alias e='emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v='vim'
alias vi='vim'
if command -v vim.tiny >/dev/null 2>&1; then
    alias vit='vim.tiny -u NONE'
else
    alias vit='vim -u NONE'
fi
alias n='nvim'

# TODO alias for remote irssi
alias rirssi='ssh -Y vividores -t .irssi/screen'

# SVN
scd() {
    local root
    root=$(svn info . 2>/dev/null | grep -F "Working Copy Root Path:" | cut -c25-)
    [ -n "$root" ] && cd "$root" || echo "Not in an SVN working copy"
}

# git aliases
alias g='git'
alias gap='git add -p'
alias gau='git add -u'
alias gca='git commit --amend'
gcd() {
    local cdup
    cdup=$(git rev-parse --show-cdup 2>/dev/null)
    [ -n "$cdup" ] && cd "$cdup" || echo "Not in a git repository"
}
alias gd='git diff'
alias gdc='git diff --cached'
alias gfa='git fetch --all'
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gst='git status'
alias gwl='git worktree list'
alias gwp='git worktree prune'

# interactive aliases use fzf
# git add interactive
gai() {
    local files
    files=$(git diff --name-only | fzf --multi) || return
    [ -n "$files" ] && echo "$files" | tr '\n' '\0' | xargs -0 git add
}
# git reset file interactive
gui() {
    local files
    files=$(git diff --name-only | fzf --multi) || return
    [ -n "$files" ] && echo "$files" | tr '\n' '\0' | xargs -0 git reset
}
# git reset HEAD file interactive (unstage file)
guci() {
    local files
    files=$(git diff --name-only --cached | fzf --multi) || return
    [ -n "$files" ] && echo "$files" | tr '\n' '\0' | xargs -0 git reset HEAD
}
# git switch branch interactive
gsb() {
    local branch
    branch=$(git branch --format='%(refname:short)' | fzf) || return
    [ -n "$branch" ] && git switch "$branch"
}
# git switch branch all interactive
gsba() {
    local branch
    branch=$(git branch -a --format='%(refname:short)' | fzf) || return
    [ -n "$branch" ] && git switch -t "$branch"
}
# git find interactive
gfi() {
    local commit
    commit=$(git log --pretty=oneline | fzf) || return
    [ -n "$commit" ] && git show "${commit%% *}"
}

# checkout pr
ghco() {
    gh pr list -L 300 | fzf --multi | awk '{print $1}' | while IFS= read -r pr; do
    gh pr checkout "$pr"
    done
}

alias gitls="git ls-files --sparse --full-name -z | \
  xargs -0 -I FILE -P 20 git log --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | \
  sort -g"

alias gitls1="git ls-files --sparse --full-name -z | \
  xargs -0 -I FILE -P 20 git log -1 --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | \
  sort -g"
