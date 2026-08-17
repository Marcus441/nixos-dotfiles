_: {
  flake.modules.nixos.core = [
    {
      hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
      };
      services.blueman.enable = true;
    }
  ];

  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.bluetoothManager.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening a Bluetooth-management UI, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
    {
      bluetoothManager.command = "blueman-manager";
      windowTags.floating-window = ["^(blueman-manager)$"];
    }
  ];
}
