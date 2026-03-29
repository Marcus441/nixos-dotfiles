{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  # kanagawa-dragon = {
  #   base00 = "#181616";
  #   base01 = "#0d0c0c";
  #   base02 = "#2d4f67";
  #   base03 = "#a6a69c";
  #   base04 = "#7fb4ca";
  #   base05 = "#c5c9c5";
  #   base06 = "#938aa9";
  #   base07 = "#c5c9c5";
  #   base08 = "#c4746e";
  #   base09 = "#e46876";
  #   base0A = "#c4b28a";
  #   base0B = "#8a9a7b";
  #   base0C = "#8ea4a2";
  #   base0D = "#8ba4b0";
  #   base0E = "#a292a3";
  #   base0F = "#7aa89f";
  # };
  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/o3/wallhaven-o32do5.jpg";
    hash = "sha256-a6stwKasoy6V6XpfqgclWiP7NSw/kAVShHkI+gx3vIE=";
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

    inherit image;
    inherit base16Scheme;
    autoEnable = false;
    targets = {
      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      ghostty.enable = true;
      gtk.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      opencode.enable = true;
      qt.enable = true;
      yazi.enable = true;
      zathura.enable = true;
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

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}
