_: {
  flake.modules.nixos.wayland = [
    {
      hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };
      services.blueman.enable = true;
    }
  ];

  flake.modules.homeManager.wayland = [
    {
      services.mpris-proxy.enable = true;
    }
  ];
}
