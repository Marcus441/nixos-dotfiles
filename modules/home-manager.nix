{inputs, ...}: {
  flake.modules.nixos.core = [
    (
      { ... }: {
        imports = [ inputs.home-manager.nixosModules.default ];
        home-manager.backupFileExtension = "backup";
      }
    )
  ];
}
