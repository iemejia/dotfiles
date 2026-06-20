# Auto-switch uv-managed Python on directory change
if command -q uv
    function _uv_hook --on-variable PWD
        set -l new_py (uv python find 2>/dev/null)
        or return
        set -l new_dir (path dirname $new_py)
        test "$new_dir" = "$_uv_python_dir"; and return
        # Remove old uv python dir from PATH
        if set -q _uv_python_dir; and set -l idx (contains -i -- $_uv_python_dir $PATH)
            set -e PATH[$idx]
        end
        set -gp PATH $new_dir
        set -g _uv_python_dir $new_dir
    end
end
