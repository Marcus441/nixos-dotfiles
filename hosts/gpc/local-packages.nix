{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud # gaming performance
    protonup
  ];
}
