# Go
fish_add_path (go env GOPATH)/bin

# NVM Node path
set -gx NVM_DIR "$HOME/.nvm"
fish_add_path "$NVM_DIR/versions/node/v26.2.0/bin"

if status is-interactive
    # fzf key bindings and completion (Ctrl+R, Ctrl+T, Alt+C)
    fzf --fish | source
end
