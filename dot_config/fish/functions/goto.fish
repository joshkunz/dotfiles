# Defined in /tmp/fish.N8oZKh/goto.fish @ line 2
function goto
    set -l match (rg --vimgrep $argv[1] | fzf | cut -d" " -f1)
    if test -z "$match"
        return 1
    end
    echo $match | read -l -d : file line ooo
    vim $file +$line
end
