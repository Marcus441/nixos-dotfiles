_: {
  flake.modules.homeManager.core = [
    {
      xdg.enable = true;

      # load-bearing: docs/decisions/xdg.md#prefer-xdg-directories
      home.preferXdgDirectories = true;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        setSessionVariables = false;
      };
    }
  ];

  flake.modules.homeManager.hyprland = [
    (
      {config, ...}: {
        xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      }
    )
  ];
}
