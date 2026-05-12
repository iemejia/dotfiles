function gsba --description 'git switch branch (all remotes) interactive (fzf)'
    set -l branch (git branch -a --format='%(refname:short)' | fzf)
    or return
    if test -n "$branch"
        git switch -t "$branch"
    end
end
