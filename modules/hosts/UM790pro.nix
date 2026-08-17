_: {
  hosts.UM790pro = {
    hostname = "UM790pro";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = ["dev" "core" "kitty" "zsh" "hyprland" "waybar" "wleave" "yazi" "apps"];

    fontSize = 20;

    hardware = ../../hosts/UM790pro/hardware-configuration.nix;

    monitors = [
      {
        name = "DP-11";
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

      # load-bearing: docs/decisions/hosts.md#nix-ld-emulator
      programs.nix-ld.libraries = with pkgs; [
        libbsd
        dbus
        libdrm
        expat
        libgbm
        nspr
        nss
        libpng
        libpulseaudio
        libuuid
        zlib
        libice
        libsm
        libx11
        libxcb
        libxext
        libxi
        libxkbfile

        libglvnd
        libxau
        vulkan-loader
        wayland
      ];

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
