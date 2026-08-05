{...}: {
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    profile = "maximal";
    dev = false;
    aspects = ["dev" "core" "maximal"];

    hardware = ../../hosts/gpc/hardware-configuration.nix;

    # Phase 3 replaces this block wholesale.
    monitors = utils: {
      monitors = [
        (utils.makeMonitor "DisplayPort-1" 2560 1440 144 0 0 1)
        (utils.makeMonitor "DisplayPort-2" 1920 1080 60 2560 0 1)
      ];
      sensitivity = 0;
    };

    packages = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        mangohud # gaming performance
        protonup-ng
      ];
    };

    nixos = {
      pkgs,
      stateVersion,
      hostname,
      config,
      lib,
      user,
      profile,
      ...
    }: {
      networking.hostName = hostname;

      # nvidia stuff
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      nixpkgs.config.allowUnfree = true;

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;

        powerManagement.finegrained = false;

        open = true;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };
      programs = {
        # gaming stuff
        steam.enable = true;
        steam.gamescopeSession.enable = true;
        gamemode.enable = true;
      };
      environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytoolds.d";
      };
      system.stateVersion = stateVersion;
    };
  };
}
