# Go
fish_add_path (go env GOPATH)/bin

if status is-interactive
    # fzf key bindings and completion (Ctrl+R, Ctrl+T, Alt+C)
    fzf --fish | source
end
