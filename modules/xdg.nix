_: {
  flake.modules.homeManager.core = [
    {
      xdg.enable = true;

      home.preferXdgDirectories = true;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        setSessionVariables = false;
      };
    }
  ];

  flake.modules.homeManager.mango = [
    (
      {config, ...}: {
        xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      }
    )
  ];
}
