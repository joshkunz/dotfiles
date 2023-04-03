function tbg
    set windows (tmux list-windows -F '#{window_index}')
    test (count $windows) -gt 0
    or begin
        echo "No windows detected, are you running in tmux?" >&2
        return 1
    end

    set candidate "not found"
    for i in (seq 9 5)
        if not contains $i $windows
            set candidate $i
            break
        end
    end

    test $candidate != "not found"
    or begin
        echo "No candidate window found. All windows 9->5 are taken."
        return 1
    end

    set cwd (pwd)

    echo "opened '$argv[1]' in window $candidate"
    tmux new-window -t $candidate -d -c $cwd $argv[1]
end
