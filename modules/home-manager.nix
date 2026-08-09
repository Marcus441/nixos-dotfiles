{inputs, ...}: {
  flake.modules.nixos.core = [
    (
      {pkgs, ...}: {
        imports = [inputs.home-manager.nixosModules.default];
        home-manager.backupFileExtension = "backup";

        environment.systemPackages = [pkgs.home-manager];
      }
    )
  ];
}
