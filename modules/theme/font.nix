_: {
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
          size = lib.mkOption {
            type = lib.types.int;
            default = 12;
            description = "Desktop UI font size, in points; scales the shell.";
          };
          terminalSize = lib.mkOption {
            type = lib.types.int;
            default = fontSize;
            description = "Terminal and monospace text size, in points.";
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
