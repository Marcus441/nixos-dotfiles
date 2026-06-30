{config, ...}: let
  inherit (config.suckless) colors font;
in {
  # Minimal notification daemon so notify-send works (ocr-copy, grimblast
  # --notify). Started inside the dwl session via `dwl -s` (see the session
  # wrapper in nixos/profiles/suckless), themed with the suckless palette.
  services.mako = {
    enable = true;
    settings = {
      font = "${font.name} ${toString font.size}";
      background-color = colors.base00;
      text-color = colors.base05;
      border-color = colors.base0D;
      border-size = 2;
      padding = 10;
      anchor = "top-right";
      default-timeout = 5000;
    };
  };
}
