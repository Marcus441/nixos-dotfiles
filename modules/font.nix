{...}: {
  # One concern, three audiences: every host needs the definition, palette
  # installs the fonts itself, stylix hands the same definition to stylix.
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
  ];

  flake.modules.homeManager.palette = [
    (
      {pkgs, ...}: {
        config = {
          home.packages = [
            pkgs.nerd-fonts.iosevka-term
            pkgs.noto-fonts
            pkgs.noto-fonts-color-emoji
            pkgs.dejavu_fonts
          ];
          fonts.fontconfig.enable = true;
        };
      }
    )
  ];

  flake.modules.homeManager.stylix = [
    (
      {
        config,
        pkgs,
        ...
      }: {
        home.packages = with pkgs; [
          font-awesome
          nerd-fonts.iosevka-term
          nerd-fonts.symbols-only
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-lgc-plus
        ];

        stylix.fonts = {
          monospace = {
            name = config.desktop.font.name;
            package = pkgs.nerd-fonts.iosevka-term;
          };
          sansSerif = {
            name = "Inter";
            package = pkgs.inter;
          };
          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
        };
      }
    )
  ];
}
