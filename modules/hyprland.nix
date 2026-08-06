{...}: {
  flake.modules.homeManager.hyprland = [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        configType = "lua";
        package = null;
        portalPackage = null;
      };
    }
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
