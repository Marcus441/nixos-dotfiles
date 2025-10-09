{pkgs, ...}: {
  home.packages = with pkgs; [
    pcmanfm-qt
  ];
  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };
}
