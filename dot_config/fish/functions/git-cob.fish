function git-cob
    git checkout (git branch --list --format="%(refname:short)" | fzf)
end
