function git-changed
    cat \
        # All of the unrecognized files. I probably created these.
        (git ls-files -o | psub) \
        # All the files that differ from what's in the working tree.
        (git diff-index --name-only HEAD | psub) \
        # All of the recognized files that have been changed.
        (git diff-files --name-only | psub) \
        # All of the files commited since the most recently merged commit.
        (git diff-tree --name-only -r HEAD (git-most-recently-merged) | psub) \
    | sort -u
end
