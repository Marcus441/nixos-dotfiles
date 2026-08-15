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

      # Google's prebuilt Android SDK binaries are FHS ELFs run through nix-ld.
      # adb and the build tools need nothing beyond glibc, but the emulator is a
      # Qt app: it bundles Qt and the xcb extensions under lib64/qt/lib and
      # expects the rest from the system. This list is every DT_NEEDED soname in
      # $ANDROID_HOME/emulator that the tree does not ship itself, plus the
      # GL/Vulkan/Wayland stack it dlopens at runtime.
      programs.nix-ld.libraries = with pkgs; [
        # linked directly
        libbsd
        dbus
        libdrm
        expat
        libgbm
        nspr # libnspr4, libplc4, libplds4
        nss # libnss3, libnssutil3, libsmime3
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

        # dlopened for rendering / windowing
        libglvnd # libGL, libEGL, libGLESv1_CM, libGLESv2
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
