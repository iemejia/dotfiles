function scd --description 'cd to svn working copy root'
    set -l root (svn info . 2>/dev/null | grep -F "Working Copy Root Path:" | cut -c25-)
    if test -n "$root"
        cd "$root"
    else
        echo "Not in an SVN working copy"
    end
end
