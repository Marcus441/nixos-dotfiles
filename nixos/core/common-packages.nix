# nixos/modules/common-packages.nix
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gh
    home-manager
    htop
    iw
    wget
  ];
}
