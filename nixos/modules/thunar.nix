{pkgs, ...}: {
  programs = {
    xfconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };
}
