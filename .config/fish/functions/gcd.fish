function gcd --description 'cd to git repo root'
    set -l cdup (git rev-parse --show-cdup 2>/dev/null)
    if test -n "$cdup"
        cd "$cdup"
    else
        echo "Not in a git repository"
    end
end
