function git-ugh
    set last_run -1
    set record_days -1
    if test -f ~/.cache/git-ugh
        cat ~/.cache/git-ugh | awk '{print $2}' | tr "\n" " " | read --list fields
        set last_run $fields[1]
        set record_days $fields[2]
    end
    git diff --quiet HEAD
    or begin
        echo "refusing to push empty commit, repo is dirty." >&2
        return
    end

    set now (date +%s)
    if test $last_run -gt 0
        set delta_days (math "floor(($now - $last_run) / 43200)")
        if test $delta_days -gt $record_days
            set record_days $delta_days
        end

        echo "It has been $delta_days days since last run; record is $record_days"
    end

    printf "%s\n" "last_run: $now" "record_days: $record_days" >~/.cache/git-ugh

    git commit --allow-empty -m "forcing cibot rebuild "(date)
    # no-verify here because we're actually pushing nothing
    and git push --no-verify
end
