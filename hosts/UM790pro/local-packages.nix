{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gcc
    gh
    git
    home-manager
    htop
    iw
    vim
    wget
  ];
}
