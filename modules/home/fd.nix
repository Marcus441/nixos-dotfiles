{...}: {
  flake.modules.homeManager.core = {
    programs.fd = {
      enable = true;
      ignores = [
        ".git/"
        "node_modules/"
      ];
    };
  };
}
