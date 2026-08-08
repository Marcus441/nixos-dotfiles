_: {
  flake.modules.homeManager.core = [
    {
      programs.zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };
    }
  ];
}
