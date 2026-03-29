{
  homeStateVersion,
  user,
  config,
  ...
}: {
  imports = [
    ./modules
    ./home-packages.nix
  ];
  gtk.gtk4.theme = config.gtk.theme;
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    shell.enableFishIntegration = true;
  };
}
