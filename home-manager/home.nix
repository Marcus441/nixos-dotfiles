{
  homeStateVersion,
  user,
  ...
}: {
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_SCREENSHOTS_DIR = "/home/${user}/Screenshots";
    };
  };
}
