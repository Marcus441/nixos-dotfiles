{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    git
    gcc
    gh
    vim
    htop
    wget
  ];
}
