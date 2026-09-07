_: {
  flake.modules.nixos.core = [
    ({pkgs, ...}: {environment.systemPackages = [pkgs.htop];})
  ];

  flake.modules.darwin.core = [
    ({pkgs, ...}: {environment.systemPackages = [pkgs.htop];})
  ];
}
