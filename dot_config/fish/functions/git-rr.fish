function git-rr
    gh pr comment (git rev-parse --abbrev-ref '@{upstream}' | cut -d/ -f2-) --body 'r?'
end
