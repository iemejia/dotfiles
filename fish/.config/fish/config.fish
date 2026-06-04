# Go
if command -q go
    fish_add_path (go env GOPATH)/bin
end

# NVM Node - find latest installed version dynamically
set -gx NVM_DIR "$HOME/.nvm"
if test -d "$NVM_DIR/versions/node"
    set -l latest_node (find "$NVM_DIR/versions/node" -maxdepth 1 -type d | sort -V | tail -1)
    test -n "$latest_node"; and fish_add_path "$latest_node/bin"
end

if status is-interactive
    # fzf key bindings and completion (Ctrl+R, Ctrl+T, Alt+C)
    fzf --fish | source

    # Fabio completion
    if command -q fabio
        fabio completions fish | source
    end
end
