_: {
  flake.modules.homeManager.core = [
    {
      programs.ripgrep = {
        enable = true;
        arguments = ["--max-columns-preview" "--smart-case"];
      };
    }
  ];
}
