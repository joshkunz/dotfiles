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
    cmake
    git
    python3
    python3-pip
    python3-pynvim
    tmux
)

no_homebrew=false
if [[ "$(uname -m)" = "aarch64" ]]; then
    # Homebrew only works on amd64
    no_homebrew=true
fi

if [[ "${no_homebrew}" = "true" ]]; then
    # try and add a bunch of equivalent APT packages that are equivalent to
    # what we'd install via brew.
    want_apt_pkgs+=(
        fd-find
        fish
        fzf
        libtree-sitter-dev
        neovim
        nodejs
        ripgrep
        tree-sitter-cli
        zoxide
    )
fi

sudo apt-get install -y "${want_apt_pkgs[@]}"

if [[ "${no_homebrew}" = "true" ]]; then
    exit 0
fi

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
    # Needed to get fish to work properly
    gcc
    neovim
    node
    ripgrep
    tree-sitter
    zoxide
)

brew update
brew install "${want_brew_pkgs[@]}"
