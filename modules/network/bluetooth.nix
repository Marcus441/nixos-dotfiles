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
    {
      windowTags.floating-window = ["^(blueman-manager)$"];
    }
  ];
}
