_: {
  flake.modules.nixos.core = [
    (
      {
        pkgs,
        user,
        ...
      }: {
        users.users.${user} = {
          isNormalUser = true;
          extraGroups = ["wheel" "networkmanager" "docker"];
          shell = pkgs.bashInteractive;
        };
      }
    )
  ];
}
