_: {
  # load-bearing: docs/decisions/sessions.md#quickshell-requires
  aspectRequires.quickshell = ["hyprland"];

  flake.modules.homeManager.quickshell = [
    (
      {
        pkgs,
        config,
        lib,
        barPosition,
        ...
      }: let
        qs = lib.getExe pkgs.quickshell;
      in {
        bar.toggle = "${qs} -c default ipc call bar toggle";
        wallpaperMenu.command = "${qs} -c default ipc call wallpaper toggle";
        powerMenu.command = "${qs} -c default ipc call powermenu toggle";

        programs.quickshell = {
          enable = true;
          activeConfig = "default";
          configs.default = import ./_config.nix {
            inherit pkgs barPosition;
            colors = config.desktop.colors;
            font = config.desktop.font;
            lockCommand = config.lock.command;
            logoutCommand = config.logout.command;
            systemMonitorCommand = config.systemMonitor.command;
            networkManagerCommand = config.networkManager.command;
          };
          systemd = {
            enable = true;
            target = "wayland-session@hyprland.desktop.target";
          };
        };
      }
    )
  ];
}
