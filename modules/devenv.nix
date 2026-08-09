_: {
  flake.modules.homeManager.dev = [
    {
      programs.devenv = {
        enable = true;
      };
    }
  ];
}
