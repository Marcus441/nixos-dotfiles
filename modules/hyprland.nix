{config, ...}: let
  top = config;
in {
  flake.modules.homeManager.hyprland = [
    # ./_hyprland is a plain module tree, not a flake-parts module, so it
    # cannot reach flake.lib itself.
    {_module.args.render = top.flake.lib.monitors;}
    ./_hyprland
  ];

  flake.modules.nixos.hyprland = [
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      security.pam.services.hyprlock = {};
    }
  ];
}
