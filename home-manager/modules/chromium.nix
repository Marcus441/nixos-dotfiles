{pkgs, ...}: {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    commandLineArgs = [
      "--ignore-gpu-blocklist"
      "--ozone-platform=wayland"
      "--enable-logging=stderr"
      "--force-color-profile=srgb"
      "--enable-blink-features=MiddleClickAutoscroll"
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
