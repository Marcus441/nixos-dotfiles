{lib, ...}: {
  # base16 "Kanagawa Dragon" palette for the lean branch (the suckless profile
  # carries no stylix, so the theme is defined explicitly here). Consumed by
  # ./bash.nix for coloured man pages; available to any other suckless module.
  options.suckless.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "base16 colour palette (hex, with leading '#') for the suckless profile.";
  };

  config.suckless.colors = {
    base00 = "#181616";
    base01 = "#0d0c0c";
    base02 = "#2d4f67";
    base03 = "#a6a69c";
    base04 = "#7fb4ca";
    base05 = "#c5c9c5";
    base06 = "#938aa9";
    base07 = "#c5c9c5";

    base08 = "#c4746e";
    base09 = "#e46876";
    base0A = "#c4b28a";
    base0B = "#8a9a7b";
    base0C = "#8ea4a2";
    base0D = "#8ba4b0";
    base0E = "#a292a3";
    base0F = "#7aa89f";
  };
}
