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
        ipc = target: fn: "${qs} -c default ipc call ${target} ${fn}";
      in {
        bar.toggle = ipc "bar" "toggle";
        powerMenu.command = ipc "powermenu" "toggle";

        # load-bearing: docs/decisions/quickshell.md#quickshell-layer-namespaces
        quickshell.overlayNamespaces = ["quickshell-powermenu" "quickshell-wallpaper"];

        media.playPause = ipc "media" "playPause";
        media.next = ipc "media" "next";
        media.previous = ipc "media" "previous";

        programs.quickshell = {
          enable = true;
          activeConfig = "default";
          configs.default = import ./_config.nix {
            inherit pkgs barPosition;
            colors = config.desktop.colors;
            roles = config.desktop.roles;
            font = config.desktop.font;
            cacheDir = config.xdg.cacheHome;
            lockCommand = config.lock.command;
            logoutCommand = config.logout.command;
            systemMonitorCommand = config.systemMonitor.command;
            processorCommand = config.systemMonitor.processorCommand;
            memoryCommand = config.systemMonitor.memoryCommand;
            temperatureCommand = config.systemMonitor.temperatureCommand;
            diskCommand = config.systemMonitor.diskCommand;
            audioMixerCommand = config.audioMixer.command;
            weatherLatitude = config.weather.latitude;
            weatherLongitude = config.weather.longitude;
            weatherTimezone = config.weather.timezone;
            wallpaperSet = config.wallpaper.set;
            wallpaperEnableRotator = config.wallpaper.enableRotator;
            wallpaperDisableRotator = config.wallpaper.disableRotator;
            wallpaperThumbnailManifest = config.wallpaper.thumbnailManifest;
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
