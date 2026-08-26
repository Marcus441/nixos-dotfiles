_: {
  flake.modules.nixos.core = [
    {
      hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
        # load-bearing: docs/decisions/audio.md#le-audio
        bluetooth.settings.General = {
          Experimental = true;
          KernelExperimental = "6fbaf188-05e0-496a-9885-d6ddfdb4e03e";
        };
      };
      services.blueman.enable = true;
    }
  ];

  flake.modules.homeManager.quickshell = [
    {
      services.blueman-applet.enable = true;
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
      # load-bearing: docs/decisions/audio.md#mpris-proxy
      services.mpris-proxy.enable = true;
    }
  ];
}
