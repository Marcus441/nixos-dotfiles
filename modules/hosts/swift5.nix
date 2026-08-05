{...}: {
  hosts.swift5 = {
    hostname = "swift5";
    system = "x86_64-linux";
    stateVersion = "25.11";
    dev = true;
    aspects = ["dev" "core" "suckless"];

    hardware = ../../hosts/swift5/hardware-configuration.nix;

    # Phase 3 replaces this block wholesale.
    monitors = utils: {
      monitors = [
        (utils.makeMonitor "eDP-1" 1920 1080 60 0 0 1)
      ];
      sensitivity = 0;
    };

    packages = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
      ];
    };

    nixos = {
      pkgs,
      stateVersion,
      hostname,
      ...
    }: {
      networking.hostName = hostname;

      system.stateVersion = stateVersion;

      networking.networkmanager.wifi.powersave = true;
    };
  };
}
