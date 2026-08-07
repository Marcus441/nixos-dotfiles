_: {
  flake.modules.homeManager.core = [
    {
      programs.jq = {
        enable = true;
      };
    }
  ];
}
