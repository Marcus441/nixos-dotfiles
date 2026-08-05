{...}: {
  hosts.UM790pro = {
    hostname = "UM790pro";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["dev" "core" "maximal"];

    hardware = ../../hosts/UM790pro/hardware-configuration.nix;

    # Phase 3 replaces this block wholesale.
    monitors = utils: {
      monitors = [
        (utils.makeMonitor "HDMI-A-1" 3840 2160 120 0 0 1.5)
      ];
      sensitivity = 1;
    };

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
