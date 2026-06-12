function vf --description 'open file in vi via fzf'
    set -l file (fzf --height=40% --reverse)
    or return
    vi $file
end
