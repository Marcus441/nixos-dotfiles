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
    {
      windowTags.floating-window = ["^(blueman-manager)$"];
      # load-bearing: docs/decisions/audio.md#mpris-proxy
      services.mpris-proxy.enable = true;
    }
  ];
}
