_: {
  flake.modules.homeManager.core = [
    {
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
