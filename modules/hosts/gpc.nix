{...}: {
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["core" "stylix" "maximal"];

    fontSize = 20;

    hardware = ../../hosts/gpc/hardware-configuration.nix;

    monitors = [
      {
        name = "DisplayPort-1";
        width = 2560;
        height = 1440;
        refresh = 144;
      }
      {
        name = "DisplayPort-2";
        width = 1920;
        height = 1080;
        x = 2560;
      }
    ];
    input.sensitivity = 0;

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
