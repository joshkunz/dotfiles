function git-dance
    set -l orig (git rev-parse --abbrev-ref HEAD)
    set -l exit_code 1
    git fetch
    and git update-ref refs/heads/master-passing-tests origin/master-passing-tests
    and git update-ref refs/heads/master origin/master
    and git deletemerged
    and git checkout $orig
    and begin
        if test $orig = master -o $orig = master-passing-tests
            git reset --merge
        end
    end
    and set exit_code 0
    or begin
        git checkout $orig
        echo "I can't dance :(" >&2
    end
    osascript -e 'display notification "git-dance complete"'
    exit $exit_code
end
