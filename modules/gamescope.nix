_: {
  flake.modules.nixos.gaming = [
    {
      programs.steam.gamescopeSession.enable = true;
    }
  ];
}
