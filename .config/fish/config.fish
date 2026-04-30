
set -U fish_greeting

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/ismael/anaconda3/bin/conda
    eval /Users/ismael/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
set HOMEBREW_FORCE_BREWED_CURL 1

# Add some easy shortcuts for formatted directory listings and add a touch of color.
alias ll 'ls -lF'
alias la 'ls -alF'
alias x 'exit'
# Make grep more user friendly by highlighting matches
# and exclude grepping through .svn folders.
alias grep 'grep --color=auto' # --exclude-dir=\.svn'
alias e 'emacsclient -t -a=\"\"' # launches emacs server if it's not up
alias v 'vim'
alias vi 'vim'
alias vit 'vim.tiny -u NONE'
alias n 'nvim'

# git aliases

alias g 'git'
alias gap 'git add -p'
alias gau 'git add -u'
alias gca='git commit --amend'
alias gcd 'cd $(git rev-parse --show-cdup)'
alias gdc 'git diff --cached'
alias gst 'git status'
alias gwl 'git worktree list'
alias gwp 'git worktree prune'

set TERM xterm-256color

