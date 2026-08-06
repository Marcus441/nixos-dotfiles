_: {
  # Not a gaming fact -- it was only ever written in gpc's host file because
  # that is where the first unfree package happened to be needed.
  flake.modules.nixos.core = [
    {
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
