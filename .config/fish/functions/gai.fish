function gai --description 'git add interactive (fzf)'
    set -l files (git diff --name-only | fzf --multi)
    or return
    if test (count $files) -gt 0
        git add $files
    end
end
