#!/bin/sh

# Variables
THEME_DIR="$HOME/.config/alacritty/themes"
REPO_URL="https://github.com/alacritty/alacritty-theme"
CONFIG_FILE="$HOME/.config/alacritty/alacritty.yml"

# Clone the themes repository if it doesn't exist
# Check if directory is empty
if ["$ls -A "$THEME_DIR")"]; then
  echo "Themes repository already exists."
  cd "$THEME_DIR" && git pull
else
  echo "Cloning themes repository..."
  git clone "$REPO_URL" "$THEME_DIR"
fi
