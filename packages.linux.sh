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
    git
)

sudo apt-get install "${want_apt_pkgs[@]}"

if ! which brew >/dev/null; then
    # Install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

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
