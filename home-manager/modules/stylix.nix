{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  # kanagawaColors:
  # base00: #0d0c0c
  # base01: #1D1C19
  # base02: #282727
  # base03: #737c73
  # base04: #a6a69c
  # base05: #c5c9c5
  # base06: #7a8382
  # base07: #c5c9c5
  # base08: #c4746e
  # base09: #b98d7b
  # base0A: #c4b28a
  # base0B: #87a987
  # base0C: #8ea4a2
  # base0D: #8ba4b0
  # base0E: #8992a7
  # base0F: #a292a3
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
    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;
      zathura.enable = true;
      zen-browser = {
        enable = true;
        profileNames = ["user"];
      };
    };

    cursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;
    };

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
      package = pkgs.tela-icon-theme;
      dark = "Tela-black-dark";
      light = "Tela-light";
    };
  };
}
