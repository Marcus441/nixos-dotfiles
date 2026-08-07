_: {
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["core" "gaming" "nvidia" "hyprland" "waybar" "wleave" "thunar" "apps"];

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
      ];
    };

    nixos = {
      stateVersion,
      hostname,
      ...
    }: {
      networking.hostName = hostname;

      system.stateVersion = stateVersion;
    };
  };
}
