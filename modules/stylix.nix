{inputs, ...}: {
  flake.modules.homeManager.stylix = [
    inputs.stylix.homeModules.stylix
    (
      {pkgs, ...}: let
        theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
      in {
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
    )
  ];
}
