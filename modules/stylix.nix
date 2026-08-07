{inputs, ...}: {
  flake.modules.homeManager.stylix = [
    inputs.stylix.homeModules.stylix
    (
      {pkgs, ...}: let
        theme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";
      in {
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
