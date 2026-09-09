_: {
  flake.modules.nixos.gaming = [
    {
      programs.gamemode = {
        enable = true;
        settings.general.renice = 10;
      };
    }
  ];
}
