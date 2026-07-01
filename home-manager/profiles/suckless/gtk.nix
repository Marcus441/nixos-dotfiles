{pkgs, ...}: {
  # Minimal, dark-first GTK theming. The suckless profile has no stylix, so
  # without this GTK apps fall back to the broken default (light theme, no
  # font rendering). Maximal is themed by stylix instead.
  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    font = {
      name = "Inter";
      size = 11;
      package = pkgs.inter;
    };

    # Ask GTK3/GTK4 apps that honour the hint to render dark.
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

    # GTK4 / libadwaita apps follow the color-scheme (dconf) below rather than a
    # named theme; applying Adwaita-dark to them can break libadwaita styling.
    gtk4.theme = null;
  };

  # libadwaita / GNOME apps ignore the theme name and read this instead.
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
