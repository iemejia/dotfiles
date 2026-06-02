function gsb --description 'git switch branch interactive (fzf)'
    set -l branch (git branch --format='%(refname:short)' | fzf)
    or return
    if test -n "$branch"
        git switch "$branch"
    end
end
