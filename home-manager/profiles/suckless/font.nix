{
  pkgs,
  lib,
  ...
}: {
  # Font definition for the lean branch: IosevkaTerm Nerd Font Mono, no ligatures.
  # Consumed by ./foot.nix; available to any other suckless module.
  options.suckless.font = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "IosevkaTerm Nerd Font Mono";
      description = "Primary monospace font family.";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 11;
      description = "Default font size, in points.";
    };
    ligatures = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable programming ligatures.";
    };
  };

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
