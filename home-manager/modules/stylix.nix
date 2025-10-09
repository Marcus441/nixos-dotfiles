{
  pkgs,
  inputs,
  ...
}: let
  # Pick your theme
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
  wallpaper = pkgs.fetchurl {
    url = "https://github.com/dharmx/walls/blob/main/abstract/a_chair_on_a_platform_with_a_halo_above_it.jpg?raw=true";
    sha256 = "sha256-3yoXPSIvUnhiaIAguxm9boBZFzkgnYMfVeXTFZ0mO5k=";
  };
in {
  imports = [inputs.stylix.homeModules.stylix];

  home.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
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
      rofi.enable = false;
      hyprland.enable = false;
    };

    cursor = {
      name = "DMZ-Black";
      size = 24;
      package = pkgs.vanilla-dmz;
    };

    opacity.terminal = 0.80;

    fonts = {
      monospace = {
        name = "JetBrains Mono";
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
