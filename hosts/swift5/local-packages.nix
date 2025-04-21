{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    git
    gcc
    gh
    kdenlive
    vim
    htop
    wget
    ];
}
