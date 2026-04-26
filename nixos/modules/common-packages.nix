# nixos/modules/common-packages.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    gh
    home-manager
    htop
    iw
    wget
  ];
}
