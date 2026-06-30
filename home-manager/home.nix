{
  homeStateVersion,
  user,
  profile,
  ...
}: {
  imports = [
    ./core
    ./profiles/${profile}
    ./home-packages.nix
  ];
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    shell.enableFishIntegration = profile == "maximal";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_SCREENSHOTS_DIR = "/home/${user}/Screenshots";
    };
  };
}
