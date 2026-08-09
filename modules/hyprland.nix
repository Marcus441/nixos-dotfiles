_: {
  flake.modules.homeManager.hyprland = [
    (
      {pkgs, ...}: {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          configType = "lua";
          package = null;
          portalPackage = null;
        };

        home.packages = [pkgs.xdg-desktop-portal-gtk];

        windowTags.floating-window = ["^(xdg-desktop-portal-gtk)$"];
      }
    )
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
