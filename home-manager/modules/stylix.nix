{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  kanagawaColors = {
    base00 = "181616";
    base01 = "0d0c0c";
    base02 = "2d4f67";
    base03 = "a6a69c";
    base04 = "7fb4ca";
    base05 = "c5c9c5";
    base06 = "938aa9";
    base07 = "c5c9c5";
    base08 = "c4746e";
    base09 = "e46876";
    base0A = "c4b28a";
    base0B = "8a9a7b";
    base0C = "8ea4a2";
    base0D = "8ba4b0";
    base0E = "a292a3";
  };
  wallpaper = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/3q/wallhaven-3q97jd.jpg";
    sha256 = "sha256-DBRyNUaySVNQ8a6I8gi5CI7eqX5Nda4nIy/QeLxGqRg=";
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
    override = kanagawaColors;
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
