{config,lib, pkgs, inputs, ... }: {
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  home.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-lgc-plus
    noto-fonts-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.jetbrains-mono
  ];
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    override = {
       base00 = "#1d2021";  # Correct the base00 color (background)
       # You can override other colors as needed, e.g., base01, base08, etc.
    };    
    targets = {
      neovim.enable = false;
      waybar.enable = false;
      wofi.enable = false;
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
      url = "https://codeberg.org/AXP-OS/wallpapers/raw/branch/main/RAW/alex-holzreiter-408703.jpg";
      sha256 = "12e026e92d2f5e3634332fc94678b9d2f57826e3cb83f852982150052d121b5a";
    };
  };
}
