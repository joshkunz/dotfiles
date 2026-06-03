function git-dance
    set -l orig (git rev-parse --abbrev-ref HEAD)
    set -l exit_code 1
    set -l tracked master green green-{gocode,zoolander,pay-server}
    git fetch
    and begin
        for branch in $tracked
            if test $orig = $branch
                git rebase
            else
                git update-ref refs/heads/$branch origin/$branch
            end
        end
    end
    and git deletemerged
    and set exit_code 0
    or begin
        echo "I can't dance :(" >&2
    end
    which -s osascript; and osascript -e 'display notification "git-dance complete"'
    return $exit_code
end
