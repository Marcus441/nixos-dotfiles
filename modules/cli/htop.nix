_: {
  flake.modules.nixos.core = [
    ({pkgs, ...}: {environment.systemPackages = [pkgs.htop];})
  ];
}
