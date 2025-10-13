{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  wallpaper = pkgs.fetchurl {
    url = "https://github.com/dharmx/walls/blob/main/nord/a_view_of_a_city_from_a_window.jpg?raw=true";
    sha256 = "sha256-oqmp8RnJOpLuJvhz41yfhKKcXS3NaVCREXW47TXsYkw=";
  };
in {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = with pkgs; [
    dejavu_fonts
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-emoji
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
      zathura.enable = false;
      nvf.enable = false;
      neovim.enable = false;
      waybar.enable = false;
      hyprland.enable = false;
      vesktop.enable = false;
    };

    cursor = {
      name = "DMZ-Black";
      size = 24;
      package = pkgs.vanilla-dmz;
    };

    # Set terminal opacity
    # opacity.terminal = 1.00;

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
