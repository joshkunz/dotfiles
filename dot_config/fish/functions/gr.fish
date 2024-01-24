function gr
    set cur $PWD
    while true
        if test -z "$cur"
            echo "somehow encountered empty path" >&2
            return 1
        end

        if test $cur = /
            # base case: We hit the root
            break
        end

        if test -d $cur/.git
            # We found a git root
            break
        end

        if test $cur = $HOME
            # we found a users home
            break
        end

        # ascend
        set cur (dirname $cur)
    end
    pushd $cur
end
