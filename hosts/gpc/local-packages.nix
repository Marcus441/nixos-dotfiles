{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    git
    gcc
    gh
    vim
    htop
    wget
    mangohud # gaming performance
    protonup
  ];
}
