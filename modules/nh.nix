_: {
  flake.modules.nixos.core = [
    (
      {user, ...}: {
        programs.nh = {
          enable = true;
          flake = "/home/${user}/.dotfiles/flake";
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep-since 14d --keep 5";
          };
        };
      }
    )
  ];

  flake.modules.darwin.core = [
    (
      {
        lib,
        pkgs,
        user,
        ...
      }: {
        environment.systemPackages = [pkgs.nh];
        environment.variables.NH_FLAKE = "/Users/${user}/.dotfiles/flake";

        launchd.daemons.nh-clean = {
          command = "${lib.getExe pkgs.nh} clean all --keep-since 14d --keep 5";
          serviceConfig.StartCalendarInterval = [
            {
              Weekday = 7;
              Hour = 3;
              Minute = 15;
            }
          ];
        };
      }
    )
  ];
}
