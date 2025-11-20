function git-pick
    set branch (git branch --list --format="%(refname:short)" | fzf)
    and git checkout $branch
end
