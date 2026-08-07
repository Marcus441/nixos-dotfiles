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
            hyprlock.enable = true;
            lazygit.enable = true;
            mako.enable = true;
            tmux.enable = true;
            yazi.enable = true;
            zathura.enable = true;
          };
        };
      }
    )
  ];
}
