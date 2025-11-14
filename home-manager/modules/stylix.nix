{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  # kanagawaColors = {
  #   base00 = "181616"; # "#181616"  → "#0d0c0c"
  #   base01 = "0D0C0C"; # "#0D0C0C"  → "#1D1C19"
  #   base02 = "2D4F67"; # "#2D4F67"  → "#282727"
  #   base03 = "A6A69C"; # "#A6A69C"  → "#737c73"
  #   base04 = "7FB4CA"; # "#7FB4CA"  → "#a6a69c"
  #   base05 = "C5C9C5"; # "#C5C9C5"  → "#c5c9c5"
  #   base06 = "938AA9"; # "#938AA9"  → "#7a8382"
  #   base07 = "C5C9C5"; # "#C5C9C5"  → "#c5c9c5"
  #   base08 = "C4746E"; # "#C4746E"  → "#c4746e"
  #   base09 = "E46876"; # "#E46876"  → "#b98d7b"
  #   base0A = "C4B28A"; # "#C4B28A"  → "#c4b28a"
  #   base0B = "8A9A7B"; # "#8A9A7B"  → "#87a987"
  #   base0C = "8EA4A2"; # "#8EA4A2"  → "#8ea4a2"
  #   base0D = "8BA4B0"; # "#8BA4B0"  → "#8ba4b0"
  #   base0E = "A292A3"; # "#A292A3"  → "#8992a7"
  #   base0F = "7AA89F"; # "#7AA89F"  → "#a292a3"
  # };
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/x1/wallhaven-x1jrqo.jpg";
    sha256 = "sha256-Lgl6LkYmrLqpyhjDlt3tLwQVtTHvOykNslX7xIr0MSk=";
  };
in {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-color-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = theme;
    targets = {
      zathura.enable = true;
      nvf.enable = false;
      neovim.enable = false;
      waybar.enable = false;
      hyprland.enable = false;
      zen-browser.profileNames = ["user"];
      vesktop.enable = false;
    };

    cursor = {
      name = "phinger-cursors-dark";
      size = 24;
      package = pkgs.phinger-cursors;
    };

    # Set terminal opacity
    opacity.terminal = 0.85;

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font Mono";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };

      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };

      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };

      sizes = {
        applications = 11;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.vimix-icon-theme;
      dark = "Vimix-beryl";
      light = "Vimix-black";
    };

    image = wallpaper;
  };
}
