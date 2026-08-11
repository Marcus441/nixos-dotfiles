_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        ...
      }: {
        # load-bearing: docs/decisions/theming.md#colors-hash
        options.desktop.colors = lib.mkOption {
          type = lib.types.attrsOf (lib.types.strMatching "#[0-9a-fA-F]{6}");
          description = "base24 colour palette (hex, with leading '#').";
        };

        options.desktop.colors16 = lib.mkOption {
          type = lib.types.attrsOf (lib.types.strMatching "#[0-9a-fA-F]{6}");
          readOnly = true;
          default = lib.filterAttrs (n: _: lib.hasPrefix "base0" n) config.desktop.colors;
          description = "the base16 subset of `desktop.colors`.";
        };

        options.desktop.colorsRgb = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          readOnly = true;
          default =
            lib.mapAttrs (
              _: hex: let
                h = lib.removePrefix "#" hex;
              in
                lib.concatMapStringsSep ";" (i: toString (lib.fromHexString (builtins.substring i 2 h))) [0 2 4]
            )
            config.desktop.colors16;
          description = "`desktop.colors16` as `r;g;b`, the parameters of a 24-bit SGR sequence.";
        };

        config.desktop.colors = {
          base00 = "#181616";
          base01 = "#282727";
          base02 = "#393836";
          base03 = "#625e5a";
          base04 = "#737c73";
          base05 = "#c5c9c5";
          base06 = "#c8c093";
          base07 = "#c5c9c5";

          base08 = "#c4746e";
          base09 = "#b6927b";
          base0A = "#c4b28a";
          base0B = "#8a9a7b";
          base0C = "#8ea4a2";
          base0D = "#8ba4b0";
          base0E = "#a292a3";
          base0F = "#b98d7b";

          base10 = "#12120f";
          base11 = "#0d0c0c";
          base12 = "#e46876";
          base13 = "#e6c384";
          base14 = "#87a987";
          base15 = "#7aa89f";
          base16 = "#7fb4ca";
          base17 = "#938aa9";
        };
      }
    )
  ];
}
