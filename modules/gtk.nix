{...}: {
  flake.modules.homeManager.palette = [
    (
      {pkgs, ...}: {
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

          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.theme = null;
        };

        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      }
    )
  ];

  # Registers the ca.desrt.dconf D-Bus service so the dconf settings above can
  # be applied. Maximal gets this implicitly via programs.thunar.
  flake.modules.nixos.palette = [
    {
      programs.dconf.enable = true;
    }
  ];
}
