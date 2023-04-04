# Copyright 2021 Google LLC.
# SPDX-License-Identifier: Apache-2.0

# Connect to or create the given tmux session.
function tmuxs --argument session
    tmux attach -t $session; or tmux new-session -s $session
end

# List the active tmux sessions in a format that is usable by autocomplete.
function _tmux_active_sessions
    set -l fmt '#{session_last_attached} #{session_name} #{session_windows}'
    for session_line in (tmux list-sessions -F $fmt 2>/dev/null | sort -rn)
        echo $session_line | read -l session_last_attached session_name session_windows
        set -l attached_str (date --date=@$session_last_attached +"%m/%d %H:%M")
        set -l desc "$session_windows windows, last $attached_str"
        printf "%s\t%s\n" $session_name $desc
    end
end

complete --command tmuxs --no-files --keep-order -a "(_tmux_active_sessions)"
