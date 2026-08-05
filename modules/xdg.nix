{...}: {
  flake.modules.homeManager.core = [
    (
      {config, ...}: {
        xdg.userDirs = {
          enable = true;
          createDirectories = true;

          setSessionVariables = false;
        };

        xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      }
    )
  ];
}
