set -euo pipefail

if ! which apt-get >/dev/null; then
    echo "apt-get not found" >&2
    exit 1
fi

if ! which dpkg-query >/dev/null; then
    echo "dpkg-query not found" >&2
    exit 1
fi

want_apt_pkgs=(
    build-essential
    clangd
    git
    python3
    python3-pip
    tmux
)

sudo apt-get install -y "${want_apt_pkgs[@]}"

if ! which brew >/dev/null; then
    # Install homebrew
    env NONINTERACTIVE=true \
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure the linuxbrew environment is sourced
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

want_brew_pkgs=(
    fd
    fish
    fzf
    neovim
    ripgrep
    tree-sitter
)

brew update
brew install "${want_brew_pkgs[@]}"

want_python_pkgs=(
    pynvim
)

pip3 install "${want_python_pkgs[@]}"
