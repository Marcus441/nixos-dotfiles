# My dotfiles

My dotfile configs. Make sure all dependencies are installed before proceeding.

## Installing Alacritty Config

1. Run `stow alacritty` while inside the dotfiles directory.
2. Install alacritty themes

```
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

## Installing Tmux Config

1. Run `stow tmux` while inside the dotfiles directory.
2. Install TPM:
   `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`.
3. Source tmux.conf file using `tmux source-file .config/tmux/tmux.conf` while
   inside a tmux session.
4. Start tmux and press `Prefix + I` to install plugins listed in `.tmux.conf`.

## Installing zsh config

1. Run `stow zsh` while inside the dotfiles directory.

## Installing Hyprland config

1. Run `stow Hyprland` while inside the dotfiles directory
2. Create relevant paths

```
mkdir -p ~/.config/waybar
mkdir -p ~/.config/wofi
mkdir -p ~/.config/dunst
mkdir -p ~/.config/scripts
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

```


## Dependencies
### Terminal
- Git
- Zsh
- Alacritty
- Tmux
- GNU Stow
- zoxide
- fzf
- jetbrains mono nerd fonts
### For Hyprland
- network-manager-applet
- wofi
- hyprpaper
- waybar
- otf-font-awesome
- cantarrel-fonts
- noto-fonts
- materia-gtk-theme
- dunst
- pipewire
- pavucontrol
- qt5-wayland and qt6-wayland
## Additional Notes

- Alacritty Themes: Ensure that the theme file paths in your alacritty.toml are
  correctly set up to use the downloaded themes.
- Tmux Configuration: After running tmux source-file, you may need to restart
  tmux or reload your tmux session to see the changes.
