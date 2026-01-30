#!/bin/bash

set -euo pipefail

# Install TPM (tmux) plugins, best effort
~/.tmux/plugins/tpm/bin/install_plugins || true

# Install Lazy (nvim) plugins
nvim --headless "+Lazy! sync" +qa
