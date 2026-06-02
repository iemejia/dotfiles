function ghco --description 'checkout GitHub PR interactive (fzf)'
    for pr in (gh pr list -L 300 | fzf --multi | awk '{print $1}')
        gh pr checkout "$pr"
    end
end
