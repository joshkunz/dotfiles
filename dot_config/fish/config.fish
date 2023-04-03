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

# auto sourced function that holds keybindings. Keybindings
# must be set in this function to be used in the shell
function fish_user_key_bindings
    bind \cb backward-word
    bind \cf forward-word
end

#### Path Updates ####
set -p PATH /home/linuxbrew/.linuxbrew/bin
# Grab out the bash-specific path modifications for rust.
set PATH /usr/local/bin $PATH
set PATH /usr/local/sbin $PATH
set PATH ~/bin $PATH
set PATH ~/.local/bin $PATH
set PATH $HOME/opt/zig-linux-x86_64-0.4.0 $PATH
# set PATH ~/.cabal/bin $PATH
# set PATH /usr/texlive/2015/bin/x86_64-linux/ $PATH
set -p PATH ~/go/bin 
set -p PATH ~/.local/texlive/2021/bin/x86_64-linux

set -l rust_path (env - bash -c 'source ~/.cargo/env; env' | rg '^PATH=' | tail -c+6 | tr ":" \n)
set -a PATH $rust_path

set fish_PKG_CONFIG_PATH
set -a fish_PKG_CONFIG_PATH "/usr/share/pkgconfig"
set -a fish_PKG_CONFIG_PATH "/usr/lib/x86_64-linux-gnu/pkgconfig"
set -a fish_PKG_CONFIG_PATH "/home/linuxbrew/.linuxbrew/lib/pkgconfig"
set -gx PKG_CONFIG_PATH (string join ":" $fish_PKG_CONFIG_PATH)

# Add Linuxbrew environment
#/home/linuxbrew/.linuxbrew/bin/brew shellenv | source

# Add OPAM environment variables
# opam config env | source

#eval set -x MANPATH (manpath | tr ':' ' ')

if test (host-os) = "Darwin"
    set PATH /Applications/Racket\ v6.3/bin $PATH
end

#### Aliases ####

alias ls "ls --color=auto -GFh"
alias ll "ls -la"

alias grep "grep --color"

alias weechat "weechat-curses"
alias irc "weechat"

alias irkt "racket -il xrepl"

if test (host-os) = "Darwin"
    alias vlc "vlcwrap"
end

alias blaze "bazel"

#### Exports ####

set -x LESS "-FRX"

set -x EDITOR nvim
set -x PAGER less
set -x LANG "en_US.UTF-8"

set -x VACTIVATE_ENVS "$HOME/code/.virtualenvs"

# For ssh-agent
if not set -q SSH_AUTH_SOCK
    set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
end

#### Helper Functions ####

function vactivate
    source $VACTIVATE_ENVS/$argv[1]/bin/activate.fish
end

#### SSh Agent ###

if not set -q SSH_AGENT_PID
    source (ssh-agent -c | rg -v '^echo' | psub)
    # Add all host keys
    ssh-add
end
