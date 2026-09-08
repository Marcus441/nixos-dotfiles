_: {
  flake.modules.nixos.dev = [
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
    }
  ];

  flake.modules.darwin.dev = [
    {homebrew.casks = ["docker-desktop"];}
  ];
}
