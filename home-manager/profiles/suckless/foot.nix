{
  config,
  lib,
  ...
}: let
  inherit (config.suckless) font;
  fontStr =
    "${font.name}:size=${toString font.size}"
    + lib.optionalString (!font.ligatures) ":fontfeatures=-calt,-liga,-clig,-dlig";
in {
  # foot: lightweight native Wayland terminal. Kept deliberately minimal -- one
  # standalone foot process per window, no server/client daemon and no session
  # plumbing (the suckless way). Font comes from ./font.nix; colours fall back
  # to foot's built-in palette.
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = fontStr;
        pad = "8x8";
      };
      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";
    };
  };
}
