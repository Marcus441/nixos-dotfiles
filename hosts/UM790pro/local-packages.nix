{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    home-manager
    git
    gcc
    gh
    vim
    htop
    wget
    linuxKernel.packages.linux_6_12.rtl88x2bu
  ];
}
