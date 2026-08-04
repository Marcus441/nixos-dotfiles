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

  # The pinned stylix drives home.pointerCursor without the (newly required)
  # explicit enable, which trips a home-manager deprecation warning. State it
  # explicitly here; drop this once stylix is updated post-refactor.
  home.pointerCursor.enable = true;

  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = theme;
    polarity = "dark";
    targets = {
      bat.enable = true;
      # Step 1.3 Option A: foot keeps its explicit base24 palette from
      # home-manager/core/foot.nix; stylix must not fight it. autoEnable is
      # already false — this is deliberate documentation, not a fix.
      foot.enable = false;
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
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
  };
}
