{
  pkgs,
  lib,
  inputs,
  ...
}: let
  helium-raw =
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

  enableFeatures = [
    "WaylandWindowDecorations"
    "VaapiVideoDecoder"
    "VaapiVideoEncoder"
    "TouchpadOverscrollHistoryNavigation"
    "HeliumNoise"
    "HeliumNoiseCanvas"
    "HeliumNoiseAudio"
    "HeliumNoiseCpuCores"
    "HeliumMiddleClickAutoscroll"
    "HeliumZenMode"
    "HeliumCompactLocationWidth"
  ];

  disableFeatures = [
  ];

  extraFlags = [
    # Wayland / Hyprland
    "--ozone-platform=wayland"
    "--gtk-version=4"
    "--enable-wayland-ime"

    # Performance
    "--enable-gpu-rasterization"
    "--disk-cache-size=52428800"

    # Helium update channel (stable)
    "--helium-update-channel=stable"

    # Privacy (ungoogled-chromium flags, still valid)
    "--disable-search-engine-collection"
    "--no-pings"
    "--fingerprinting-canvas-image-data-noise"
    "--fingerprinting-client-rects-noise"
    "--fingerprinting-canvas-measuretext-noise"

    # UI cleanup
    "--hide-extensions-menu"
    "--remove-tabsearch-button"
    "--remove-grab-handle"
    "--close-window-with-last-tab=never"
  ];

  allFlags =
    [
      "--enable-features=${lib.concatStringsSep "," enableFeatures}"
      "--disable-features=${lib.concatStringsSep "," disableFeatures}"
    ]
    ++ extraFlags;
in {
  home.packages = [
    (pkgs.symlinkJoin {
      name = "helium";
      paths = [helium-raw];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/helium \
          --add-flags "${lib.concatStringsSep " " allFlags}"
      '';
    })
  ];
}
