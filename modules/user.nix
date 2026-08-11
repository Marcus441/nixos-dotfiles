_: {
  flake.modules.nixos.core = [
    (
      {
        config,
        lib,
        pkgs,
        user,
        ...
      }: {
        options.loginShell = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bashInteractive;
          description = "The shell `${user}` logs into. A shell aspect overrides it.";
        };

        config.users.users.${user} = {
          isNormalUser = true;
          extraGroups = ["wheel" "networkmanager" "docker"];
          shell = config.loginShell;
        };
      }
    )
  ];
}
