_: {
  hosts.UM790pro = {
    hostname = "UM790pro";
    system = "x86_64-linux";
    stateVersion = "25.11";
    aspects = [
      "dev"
      "core"
      "zsh"
      "wayland"
      "firefox"
      "foot"
      "dwl"
      "dwl-bar"
      "apps"
      "keychron"
    ];

    fontSize = 16;

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
    input.sensitivity = 0;

    packages = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
      ];
    };

    machine = {
      stateVersion,
      hostname,
      pkgs,
      ...
    }: {
      networking.hostName = hostname;
      networking.networkmanager.wifi.powersave = false;
      programs.nix-ld.enable = true;

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
