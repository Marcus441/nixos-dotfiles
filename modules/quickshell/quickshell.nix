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
        ipc = target: "${qs} -c default ipc call ${target} toggle";
      in {
        bar.toggle = ipc "bar";
        wallpaperMenu.command = ipc "wallpaper";
        powerMenu.command = ipc "powermenu";

        programs.quickshell = {
          enable = true;
          activeConfig = "default";
          configs.default = import ./_config.nix {
            inherit pkgs barPosition;
            colors = config.desktop.colors;
            font = config.desktop.font;
            cacheDir = config.xdg.cacheHome;
            lockCommand = config.lock.command;
            logoutCommand = config.logout.command;
            systemMonitorCommand = config.systemMonitor.command;
            processorCommand = config.systemMonitor.processorCommand;
            memoryCommand = config.systemMonitor.memoryCommand;
            temperatureCommand = config.systemMonitor.temperatureCommand;
            networkManagerCommand = config.networkManager.command;
            wallpaperSet = config.wallpaper.set;
            wallpaperEnableRotator = config.wallpaper.enableRotator;
            wallpaperDisableRotator = config.wallpaper.disableRotator;
            wallpaperDirectory = config.wallpaper.directory;
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
