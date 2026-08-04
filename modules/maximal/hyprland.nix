{...}: {
  flake.modules.homeManager.maximal = [
    ./_hyprland
  ];

  flake.modules.nixos.maximal = [
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
