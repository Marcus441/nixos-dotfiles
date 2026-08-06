{...}: {
  hosts.swift5 = {
    hostname = "swift5";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["dev" "core" "dwl" "palette"];

    fontSize = 16;

    hardware = ../../hosts/swift5/hardware-configuration.nix;

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
      }
    ];
    input.sensitivity = 0;

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
