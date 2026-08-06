_: {
  flake.modules.nixos.core = [
    {
      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };
    }
  ];
}
