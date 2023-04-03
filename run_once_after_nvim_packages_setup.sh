#!/usr/bin/env bash

set -euo pipefail

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
