{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    gh
    git
    home-manager
    htop
    iw
    mangohud # gaming performance
    protonup
    vim
    wget
  ];
}
