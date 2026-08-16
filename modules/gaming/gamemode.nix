_: {
  flake.modules.nixos.gaming = [
    {
      programs.gamemode = {
        enable = true;

        # load-bearing: docs/decisions/gaming.md#gamemode-governor
        settings.general.renice = 10;
      };
    }
  ];
}
