{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--ozone-platform=wayland"
      "--force-color-profile=srgb"
      "--enable-blink-features=MiddleClickAutoscroll"
      "--enable-features=UseOzonePlatform,VaapiVideoDecoder,OverlayStrategies,RawDraw,AcceleratedVideoDecode,ThreadedScrolling,SmoothScrolling"
      "--disable-features=UseSkiaRenderer"
      "--enable-zero-copy"
      "--enable-gpu-rasterization"
      "--enable-native-gpu-memory-buffers"
      "--enable-features=CanvasOopRasterization"
    ];
    dictionaries = [pkgs.hunspellDictsChromium.en_US];
    extensions = [
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      {id = "dhdgffkkebhmkfjojejmpbldmpobfkfo";} # Tampermonkey
      {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # uBlock Origin Lite
      {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # Sponsor Block
      {id = "nngceckbapebfimnlniiiahkandclblb";} # Vault Warden
    ];
  };
}
