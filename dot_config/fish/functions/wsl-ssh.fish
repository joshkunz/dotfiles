function wsl-ssh --wraps=ssh
    ssh.exe -F (wslpath -w ~/.ssh/config) $argv
end
