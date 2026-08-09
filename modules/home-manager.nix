{inputs, ...}: {
  flake.modules.nixos.core = [
    (
      {pkgs, ...}: {
        imports = [inputs.home-manager.nixosModules.default];
        home-manager.backupFileExtension = "backup";

        # The CLI belongs with the module: `home-manager switch` is how this
        # host is expected to be driven.
        environment.systemPackages = [pkgs.home-manager];
      }
    )
  ];
}
