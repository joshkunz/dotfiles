#!/bin/bash

set -euo pipefail

if ! which dnf >/dev/null; then
    echo "dnf not found" >&2
    exit 1
fi

want_pkgs=(
    clangd
    cmake
    fd-find
    fish
    fzf
    git
    neovim
    node
    python3
    ripgrep
    tmux
    tree-sitter
    zoxide
)

sudo dnf --assumeyes install "${want_pkgs[@]}"
