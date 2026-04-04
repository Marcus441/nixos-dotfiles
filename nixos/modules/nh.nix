{user, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/${user}/flake";
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
