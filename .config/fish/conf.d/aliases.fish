# Abbreviations and aliases - fish equivalent of ~/.bash_aliases
# Uses fish abbreviations (expand when typed) for short commands
# Complex commands use alias (function wrapper) to avoid cluttering the command line

if not status is-interactive
    return
end

# Directory listings (fish handles ls --color natively)
abbr --add ll 'ls -alF'
abbr --add la 'ls -A'
alias l='ls -CF'

# Quick exit
alias x='exit'

# Editors
alias e='emacsclient -t -a=""'
alias v='vim'
alias vi='vim'
alias n='nvim'

# Remote irssi
abbr --add rirssi 'ssh -Y vividores -t .irssi/screen'

# Git - simple aliases as abbreviations
alias g='git'
abbr --add gap 'git add -p'
abbr --add gau 'git add -u'
abbr --add gca 'git commit --amend'
abbr --add gd 'git diff'
abbr --add gdc 'git diff --cached'
abbr --add gfa 'git fetch --all'
abbr --add gst 'git status'
abbr --add gwl 'git worktree list'
abbr --add gwp 'git worktree prune'

# Git log - use alias to avoid expanding the long format string
alias glg="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# Git ls - use alias for complex pipe commands
alias gitls="git ls-files --sparse --full-name -z | xargs -0 -I FILE -P 20 git log --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | sort -g"
alias gitls1="git ls-files --sparse --full-name -z | xargs -0 -I FILE -P 20 git log -1 --date=iso-strict-local --format='%ad %>(14) %cr %<(5) %an  %h ./FILE' -- FILE | sort -g"
