_: {
  flake.modules.nixos.core = [
    {
      nixpkgs.config.allowUnfree = true;
    }
  ];
  flake.modules.homeManager.core = [
    {
      nixpkgs.config.allowUnfree = true;
    }
  ];
}
