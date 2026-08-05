{...}: {
  flake.modules.nixos.core = [
    {
      hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };
      services.blueman.enable = true;
    }
  ];
}
