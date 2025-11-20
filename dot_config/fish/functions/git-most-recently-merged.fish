function git-most-recently-merged
    git log --grep='Squashed by Merge Queue' -n1 --format="%H"
end
