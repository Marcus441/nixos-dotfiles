{...}: {
  hosts.UM790pro = {
    hostname = "UM790pro";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["dev" "core" "hyprland" "stylix" "maximal"];

    fontSize = 20;

    hardware = ../../hosts/UM790pro/hardware-configuration.nix;

    monitors = [
      {
        name = "HDMI-A-1";
        description = "Dell Inc. DELL S2725QC B1WK464";
        width = 3840;
        height = 2160;
        refresh = 120;
        scale = 1.5;
      }
    ];
    input.sensitivity = 1;

    packages = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
      ];
    };

    nixos = {
      stateVersion,
      hostname,
      pkgs,
      ...
    }: {
      networking.hostName = hostname;
      networking.networkmanager.wifi.powersave = false;
      programs.nix-ld.enable = true;

      system.stateVersion = stateVersion;
      boot = {
        kernelParams = ["usbcore.autosuspend=-1"];
      };
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev $name set power_save off"
      '';
    };
  };
}
