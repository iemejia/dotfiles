function gui --description 'git reset file interactive (fzf)'
    set -l files (git diff --name-only | fzf --multi)
    or return
    if test (count $files) -gt 0
        git reset $files
    end
end
