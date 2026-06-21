# Auto-switch uv-managed Python on directory change
if command -q uv
    function _uv_hook --on-variable PWD
        set -l new_py (uv python find 2>/dev/null)
        or return
        set -l new_dir (path dirname $new_py)
        test "$new_dir" = "$_uv_python_dir"; and return
        # Remove all uv python dirs from PATH (handles stale inherited entries)
        for i in (seq (count $PATH) -1 1)
            if string match -q '*/uv/python/cpython-*' $PATH[$i]
                set -e PATH[$i]
            end
        end
        set -gp PATH $new_dir
        set -g _uv_python_dir $new_dir
    end
end
