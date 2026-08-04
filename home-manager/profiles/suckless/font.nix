{pkgs, ...}: {
  # Font packages for the lean branch. The shared font *definition*
  # (suckless.font) moved to home-manager/core/font.nix in step 1.3.
  config = {
    home.packages = [
      pkgs.nerd-fonts.iosevka-term # primary mono / terminal / icon glyphs
      # General-purpose coverage: IosevkaTerm alone has no proportional UI
      # faces, emoji or wide script coverage, which firefox and other apps
      # need. (CJK is opt-in: add pkgs.noto-fonts-cjk-sans if required.)
      pkgs.noto-fonts # sans + serif (Latin / Greek / Cyrillic, web text)
      pkgs.noto-fonts-color-emoji # colour emoji
      pkgs.dejavu_fonts # broad metric-compatible fallback
    ];
    fonts.fontconfig.enable = true;
  };
}
