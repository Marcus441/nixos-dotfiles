_: {
  flake.modules.nixos.gaming = [
    {
      programs.steam.gamescopeSession.enable = true;

      programs.gamescope = {
        capSysNice = true;
        args = ["--rt" "--adaptive-sync"];
      };
    }
  ];
}
