_: {
  flake.modules.nixos.gaming = [
    {
      programs.steam.gamescopeSession.enable = true;

      programs.gamescope = {
        # load-bearing: docs/decisions/gaming.md#gamescope-wrapper
        capSysNice = true;

        args = ["--rt" "--adaptive-sync"];
      };
    }
  ];
}
