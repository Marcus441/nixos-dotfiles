{
  config,
  lib,
  ...
}: let
  inherit (config.suckless) font colors;
  fontStr =
    "${font.name}:size=${toString font.size}"
    + lib.optionalString (!font.ligatures) ":fontfeatures=-calt,-liga,-clig,-dlig";

  strip = c: lib.removePrefix "#" c;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = fontStr;
        pad = "8x8";
      };
      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";

      colors-dark = {
        background = strip colors.base00;
        foreground = strip colors.base05;

        cursor = "${strip colors.base00} ${strip colors.base05}";

        regular0 = strip colors.base00;
        regular1 = strip colors.base08;
        regular2 = strip colors.base0B;
        regular3 = strip colors.base0A;
        regular4 = strip colors.base0D;
        regular5 = strip colors.base0E;
        regular6 = strip colors.base0C;
        regular7 = strip colors.base05;

        bright0 = strip colors.base03;
        bright1 = strip colors.base08;
        bright2 = strip colors.base0B;
        bright3 = strip colors.base0A;
        bright4 = strip colors.base0D;
        bright5 = strip colors.base0E;
        bright6 = strip colors.base0C;
        bright7 = strip colors.base07;

        selection-foreground = strip colors.base00;
        selection-background = strip colors.base05;
      };
    };
  };
}
