function sdk
    # SDKMAN wrapper for fish - delegates to bash since sdk is a bash function
    set -l sdk_init "$SDKMAN_DIR/bin/sdkman-init.sh"
    if not test -s "$sdk_init"
        echo "SDKMAN not found. Install from https://sdkman.io" >&2
        return 1
    end

    # Run sdk in bash subshell, then capture the resulting PATH and JAVA_HOME
    set -l bash_output (bash -c "export SDKMAN_DIR=\"$SDKMAN_DIR\"; source \"$sdk_init\"; sdk $argv; echo \"__FISH_SDK_PATH=\$PATH\"; echo \"__FISH_SDK_JAVA_HOME=\$JAVA_HOME\"" 2>&1)
    set -l bash_status $status

    # Print all output except our marker lines
    for line in $bash_output
        switch $line
            case '__FISH_SDK_PATH=*'
                # Update fish PATH from the bash result
                set -gx PATH (string split ':' (string replace '__FISH_SDK_PATH=' '' $line))
            case '__FISH_SDK_JAVA_HOME=*'
                set -l new_java_home (string replace '__FISH_SDK_JAVA_HOME=' '' $line)
                if test -n "$new_java_home"
                    set -gx JAVA_HOME "$new_java_home"
                end
            case '*'
                echo $line
        end
    end

    return $bash_status
end
