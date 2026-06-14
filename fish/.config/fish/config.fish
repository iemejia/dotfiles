# Go - add GOPATH/bin (env.fish sets GOPATH if ~/gowork exists;
# otherwise use Go's default ~/go without forking `go env`)
if set -q GOPATH
    fish_add_path $GOPATH/bin
else if test -d "$HOME/go/bin"
    fish_add_path "$HOME/go/bin"
end

# NVM Node - add latest installed version to PATH (no forks, uses glob)
set -gx NVM_DIR "$HOME/.nvm"
if test -d "$NVM_DIR/versions/node"
    set -l node_dirs $NVM_DIR/versions/node/v*/bin
    if test (count $node_dirs) -gt 0
        fish_add_path $node_dirs[-1]
    end
end

if status is-interactive
    # fzf: Ctrl-O inside Ctrl-T picker opens selection in vi
    set -gx FZF_CTRL_T_OPTS "--bind 'ctrl-o:execute(vi {})+abort'"

    # fzf key bindings and completion (cached to avoid forking on every shell)
    set -l _fzf_cache "$HOME/.cache/fish/fzf-init.fish"
    if not test -f "$_fzf_cache"; or test (command -s fzf) -nt "$_fzf_cache"
        mkdir -p (dirname "$_fzf_cache")
        fzf --fish > "$_fzf_cache" 2>/dev/null
    end
    source "$_fzf_cache"

    # Fabio completion (cached)
    if command -q fabio
        set -l _fabio_cache "$HOME/.cache/fish/fabio-completions.fish"
        if not test -f "$_fabio_cache"; or test (command -s fabio) -nt "$_fabio_cache"
            mkdir -p (dirname "$_fabio_cache")
            fabio completions fish > "$_fabio_cache" 2>/dev/null
        end
        source "$_fabio_cache"
    end

    # Starship prompt
    if command -q starship
        starship init fish | source
    end

    # Television fuzzy finder shell integration
    if command -q tv
        tv init fish | source
    end

    # Carapace multi-shell completion
    if command -q carapace
        set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense'
        set -Ux CARAPACE_MATCH 1
        carapace _carapace fish | source
    end
end
