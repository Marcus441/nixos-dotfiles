{user, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/${user}/flake";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 14d --keep 5";
    };
  };
}
