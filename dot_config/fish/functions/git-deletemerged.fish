function git-deletemerged
    # Prune branches that have been removed upstream.
    git remote prune origin
    # Print each ref along with its upstream if it exists, otherwise print
    # NO_UPSTREAM in the position of the upstream.
    set -l fmt "%(refname) %(if)%(upstream)%(then)%(upstream)%(else)NO_UPSTREAM%(end)"
    set to_delete
    git for-each-ref --format=$fmt refs/heads | while read -l -d" " local upstream
        if test $upstream = NO_UPSTREAM
            continue
        end
        # Check if the upstream tracking branch exists. If so, don't delete.
        if git show-ref --quiet --verify $upstream
            continue
        end

        # Finally, if a branch has an upstream tracking branch that has been
        # deleted, delete the local branch.
        set -l branch (echo $local | sed -E 's|refs/heads/(.*)|\1|')
        set -a to_delete $branch
    end

    # Try deleting branches if ther eare any that need to be cleaned up.
    if test (count $to_delete) -gt 0
        printf '  %s\n' $to_delete
        set plural 'this branch'
        if test (count $to_delete) -gt 1
            set plural 'these branches'
        end
        if yn "Delete $plural?"
            for branch in $to_delete
                # In theory, we could use git update-ref -d to do this on the ref
                # directly, but that can leave us with an abandoned head. git branch
                # -D is a bit safer.
                git branch -D $branch 2>/dev/null
            end
        end
    end

    return 0
end
