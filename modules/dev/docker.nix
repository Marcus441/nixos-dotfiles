_: {
  flake.modules.nixos.dev = [
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
    }
  ];
}
