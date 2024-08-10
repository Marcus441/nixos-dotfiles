#!/bin/sh

# Directory where TPM should be cloned
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Check if TPM directory exists
if [ ! -d "$TPM_DIR" ]; then
  echo "TPM not found. Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm $TPM_DIR
else
  echo "TPM already installed."
fi
