{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  helium-raw = inputs.helium.defaultPackage.${system};

  enableFeatures = [
    "SmoothScrolling"
    "ThreadedScrolling"
    "CanvasOopRasterization"

    "LazyFrameLoading"
    "LazyImageLoading"
    "TabDiscarding"
    "TabFreeze"
    "FastUnload"

    "VaapiVideoDecoder"

    "UseOzonePlatform"
    "WaylandFractionalScaleV1"
  ];

  disableFeatures = [
    "ChromeWhatsNewUI"
    "TranslateUI"
    "OptimizationHints"
  ];

  allFlags = [
    "--ozone-platform=wayland"

    "--enable-gpu-compositing"
    "--enable-oop-rasterization"

    "--enable-async-dns"
    "--enable-quic"

    "--disable-breakpad"
    "--disable-crash-reporter"
    "--disable-sync"

    "--enable-features=${lib.concatStringsSep "," enableFeatures}"
    "--disable-features=${lib.concatStringsSep "," disableFeatures}"
  ];
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

  # Note: Extensions for Helium (as an AppImage/Flake) are best installed
  # manually via the web store to ensure they persist correctly in the
  # AppImage's user data directory.
}
