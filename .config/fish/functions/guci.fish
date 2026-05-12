function guci --description 'git unstage file interactive (fzf)'
    set -l files (git diff --name-only --cached | fzf --multi)
    or return
    if test (count $files) -gt 0
        git reset HEAD $files
    end
end
