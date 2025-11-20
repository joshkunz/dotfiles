function git-co --wraps='git checkout'
    echo "got args" $argv >&2
    if test (count $argv) -gt 0
        git checkout $argv
    else
        git checkout (git branch --list --format="%(refname:short)" | fzf)
    end
end
