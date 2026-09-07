_: {
  flake.modules.homeManager.apps = [
    (
      {
        lib,
        pkgs,
        ...
      }: {
        programs.obs-studio = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        };
      }
    )
  ];
}
