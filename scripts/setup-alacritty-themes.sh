#!/bin/sh

# Variables
THEME_DIR="$HOME/.config/alacritty/"
REPO_URL="https://github.com/alacritty/alacritty-theme"
CONFIG_FILE="$HOME/.config/alacritty/alacritty.yml"

# Create the theme directory if it doesn't exist
mkdir -p "$THEME_DIR/themes"

# Clone the themes repository if it doesn't exist
if [ ! -d "$THEME_DIR/themes" ]; then
  echo "Cloning themes repository..."
  git clone "$REPO_URL" "$THEME_DIR/themes"
else
  echo "Themes repository already exists."
  cd "$THEME_DIR/themes" && git pull
fi
