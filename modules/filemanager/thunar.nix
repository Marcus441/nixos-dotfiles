_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.fileManager.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening a file-manager window, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.thunar = [
    {
      fileManager.command = "thunar";

      windowTags = {
        floating-window = ["^(thunar|Thunar)$"];
        no-anim = ["^(thunar|Thunar)$"];
      };

      xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
    }
  ];

  flake.modules.nixos.thunar = [
    (
      {pkgs, ...}: {
        programs = {
          xfconf.enable = true;
          thunar = {
            enable = true;
            plugins = with pkgs; [
              thunar-archive-plugin
              thunar-volman
            ];
          };
        };
        services = {
          gvfs.enable = true;
          tumbler.enable = true;
        };

        # load-bearing: docs/decisions/tui.md#thunar-daemon
        systemd.user.services.thunar = {
          partOf = ["graphical-session.target"];
          after = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          serviceConfig.Slice = "app-graphical.slice";
        };
      }
    )
  ];
}
