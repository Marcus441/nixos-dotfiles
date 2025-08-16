{
  pkgs,
  inputs,
  ...
}: {
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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    override = {
      base00 = "#1d2021"; # Correct the base00 color (background)
      # You can override other colors as needed, e.g., base01, base08, etc.
    };
    targets = {
      neovim.enable = false;
      waybar.enable = false;
      rofi.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
    };

    cursor = {
      name = "DMZ-Black";
      size = 24;
      package = pkgs.vanilla-dmz;
    };

    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      monospace = {
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };

      sizes = {
        terminal = 13;
        applications = 11;
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/m3/wallhaven-m3y8pm.jpg";
      sha256 = "c050e26db121ac76606b9671af8c99b609e2114aca248036e7fc50e5bc026960";
    };
  };
}
