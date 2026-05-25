{pkgs, ...}: let
  theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
in {
  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
  ];

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = theme;
    polarity = "dark";
    targets = {
      bat.enable = true;
      fish.enable = true;
      ghostty.enable = true;
      gtk.enable = true;
      hyprlock.enable = true;
      lazygit.enable = true;
      mako.enable = true;
      qt.enable = true;
      tmux.enable = true;
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
        name = "IosevkaTerm Nerd Font Mono";
        package = pkgs.nerd-fonts.iosevka-term;
      };
      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  gtk = {
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4 = {
      theme = null;
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}
