{config, ...}: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    # Adopt the new API default behavior to silence the warning
    setSessionVariables = false;
  };

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
