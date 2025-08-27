
set -U fish_greeting

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/ismael/anaconda3/bin/conda
    eval /Users/ismael/anaconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
set HOMEBREW_FORCE_BREWED_CURL 1
