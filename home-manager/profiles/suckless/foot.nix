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
        initial-color-theme = "dark";
      };
      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";

      # base24 terminal mapping (./colors.nix): brights from base12-17,
      # extended colours 16/17 from base09/base0F.
      colors-dark = {
        foreground = strip colors.base05;
        background = strip colors.base00;

        selection-foreground = strip colors.base06;
        selection-background = strip colors.base02;

        regular0 = strip colors.base11;
        regular1 = strip colors.base08;
        regular2 = strip colors.base0B;
        regular3 = strip colors.base0A;
        regular4 = strip colors.base0D;
        regular5 = strip colors.base0E;
        regular6 = strip colors.base0C;
        regular7 = strip colors.base06;

        bright0 = strip colors.base03;
        bright1 = strip colors.base12;
        bright2 = strip colors.base14;
        bright3 = strip colors.base13;
        bright4 = strip colors.base16;
        bright5 = strip colors.base17;
        bright6 = strip colors.base15;
        bright7 = strip colors.base07;

        "16" = strip colors.base09;
        "17" = strip colors.base0F;
      };
    };
  };
}
