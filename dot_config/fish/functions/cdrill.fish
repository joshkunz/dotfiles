function cdrill
    if in_git_dir
        cd (git ls-files | rev | cut -d/ -f2- | rev | awk '!a[$0]++' | fzf)
    else
        cd (fd --type directory | fzf)
    end

end
