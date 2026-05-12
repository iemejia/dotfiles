function gfi --description 'git find commit interactive (fzf)'
    set -l commit (git log --pretty=oneline | fzf)
    or return
    if test -n "$commit"
        git show (string split ' ' -- "$commit")[1]
    end
end
