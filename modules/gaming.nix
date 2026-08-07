_: {
  flake.modules.nixos.gaming = [
    (
      {
        pkgs,
        user,
        ...
      }: {
        programs = {
          steam.enable = true;
          steam.gamescopeSession.enable = true;
          gamemode.enable = true;
        };

        environment.sessionVariables = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytools.d";
        };

        environment.systemPackages = with pkgs; [
          mangohud
          protonup-ng
        ];
      }
    )
  ];
}
