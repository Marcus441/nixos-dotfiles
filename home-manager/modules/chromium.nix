{
  pkgs,
  lib,
  ...
}: let
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
in {
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-background-networking"
      "--disable-background-timer-throttling"
      "--disable-client-side-phishing-detection"
      "--disable-component-update"
      "--disable-default-apps"
      "--disable-software-rasterizer"
      "--disable-sync"
      "--enable-async-dns"
      "--enable-blink-features=MiddleClickAutoscroll"
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
    dictionaries = [pkgs.hunspellDictsChromium.en_US];
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # Sponsor Block
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Bit Warden
    ];
  };
}
