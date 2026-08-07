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

  # uwsm is how the Hyprland session starts (bash.nix), and it reads this to
  # inherit home-manager's session variables. dwl sources them from the login
  # shell instead, so swift5 has no use for the file.
  flake.modules.homeManager.hyprland = [
    (
      {config, ...}: {
        xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      }
    )
  ];
}
