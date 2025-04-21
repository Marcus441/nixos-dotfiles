{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    git
    gcc
    kdenlive
    vim
    htop
    wget
    ];
}
