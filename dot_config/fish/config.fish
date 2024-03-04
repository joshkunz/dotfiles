# Clear out the greeting.
set fish_greeting

# The current time in a 12 hour format
function 12-hour-time
    date +"%I:%M:%S"
end

function host-os
    uname -s
end

# Output's the entire path (no shortening) with the
# part that is the user's home directory replaced with ~
function full-pwd
    pwd | sed -e s!^(echo ~)!~!
end

# Outputs arguments [2...] in color
# given in argument [1].
function color-text
    set_color $argv[1]
    echo -n $argv[2..(count $argv)]
    set_color normal
end

function fish_prompt
    printf "%s (%s) %s:%s\n%s " \
        (12-hour-time) \
        (color-text white (hostname)) \
        (color-text red (whoami)) \
        (color-text 85e7ff (full-pwd)) \
        "><>"
end

#### Key Bindings ####

fish_vi_key_bindings

#### Path Updates ####

function maybe_add_path
    argparse 'p' -- $argv
    or return

    # skip if this path doesn't exist
    not test -d $argv[1]
    and return 0

    if set -q _flag_p
        set -p PATH $argv[1]
    else
        set -a PATH $argv[1]
    end
end

maybe_add_path -p /home/linuxbrew/.linuxbrew/bin
maybe_add_path /usr/local/bin
maybe_add_path /usr/local/sbin
maybe_add_path -p ~/.local/bin
maybe_add_path $HOME/opt/zig-linux-x86_64-0.4.0 $PATH
maybe_add_path ~/.cabal/bin
maybe_add_path -p ~/go/bin
maybe_add_path /usr/local/go/bin

if test -d ~/.cargo/env
    set -l rust_path (env - bash -c 'source ~/.cargo/env; env' | rg '^PATH=' | tail -c+6 | tr ":" \n)
    set -a PATH $rust_path
end

if test (hostname) = "apollo"
    set fish_PKG_CONFIG_PATH
    set -a fish_PKG_CONFIG_PATH "/usr/share/pkgconfig"
    set -a fish_PKG_CONFIG_PATH "/usr/lib/x86_64-linux-gnu/pkgconfig"
    set -a fish_PKG_CONFIG_PATH "/home/linuxbrew/.linuxbrew/lib/pkgconfig"
    set -gx PKG_CONFIG_PATH (string join ":" $fish_PKG_CONFIG_PATH)
end

#### Aliases ####

alias ls "ls --color=auto -GFh"
alias ll "ls -la"

alias grep "grep --color"

alias blaze "bazel"

alias R "R --no-save"

#### Exports ####

set -x LESS "-FRX"

set -x EDITOR nvim
set -x PAGER less
set -x LANG "en_US.UTF-8"
set -x LC_ALL $LANG

set -q GHCUP_INSTALL_BASE_PREFIX[1]
or set GHCUP_INSTALL_BASE_PREFIX $HOME
fish_add_path -p $HOME/.ghcup/bin
fish_add_path -p $HOME/.cabal/bin

#### SSH Agent ####

# For ssh-agent
if not set -q SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
end

if not set -q SSH_AGENT_PID
    source (ssh-agent -c | rg -v '^echo' | psub)
    # Add all host keys
    ssh-add
end

#### Zoxide ####

zoxide init fish --cmd cd | source
