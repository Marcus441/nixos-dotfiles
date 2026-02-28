{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  helium-raw = inputs.helium.defaultPackage.${system};

  enableFeatures = [
    "AcceleratedVideoDecode"
    "CanvasOopRasterization"
    "FastUnload"
    "LazyFrameLoading"
    "LazyImageLoading"
    "OverlayStrategies"
    "Prerender2"
    "SmoothScrolling"
    "TabDiscarding"
    "TabFreeze"
    "ThreadedScrolling"
    "UseOzonePlatform"
    "VaapiVideoDecoder"
    "WebContentsOcclusion"
  ];

  disableFeatures = [
    "AutofillServerCommunication"
    "BlinkGenPropertyTrees"
    "ChromeWhatsNewUI"
    "TranslateUI"
    "UseSkiaRenderer"
  ];

  allFlags = [
    "--disable-background-networking"
    "--disable-background-timer-throttling"
    "--disable-client-side-phishing-detection"
    "--disable-component-update"
    "--disable-default-apps"
    "--disable-software-rasterizer"
    "--disable-sync"
    "--enable-async-dns"
    "--enable-gpu-compositing"
    "--enable-gpu-rasterization"
    "--enable-native-gpu-memory-buffers"
    "--enable-prefetch"
    "--enable-zero-copy"
    "--force-color-profile=srgb"
    "--ignore-gpu-blocklist"
    "--ozone-platform=wayland"
    "--safebrowsing-disable-auto-update"
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
