_: {
  flake.modules.nixos.wayland = [
    {
      hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };
    }
  ];
}
