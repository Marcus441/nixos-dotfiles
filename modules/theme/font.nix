_: {
  # The option is what other files read; the packages are what put the fonts on
  # disk. Both belong to every host, so both are core.
  flake.modules.homeManager.core = [
    (
      {
        lib,
        fontSize,
        ...
      }: {
        options.desktop.font = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "IosevkaTerm Nerd Font Mono";
            description = "Primary monospace font family.";
          };
          # Point size is a property of the panel, not of the theme, so it
          # arrives from the host record rather than from an aspect.
          size = lib.mkOption {
            type = lib.types.int;
            default = fontSize;
            description = "Default font size, in points.";
          };
          ligatures = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to enable programming ligatures.";
          };
        };
      }
    )

    (
      {pkgs, ...}: {
        # The union of what the two theming regimes installed. Which fonts a
        # machine has is not a theming decision -- a missing glyph is a missing
        # glyph under either palette.
        home.packages = with pkgs; [
          dejavu_fonts
          font-awesome
          inter
          nerd-fonts.iosevka-term
          nerd-fonts.symbols-only
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-lgc-plus
        ];
        fonts.fontconfig.enable = true;
      }
    )
  ];
}
