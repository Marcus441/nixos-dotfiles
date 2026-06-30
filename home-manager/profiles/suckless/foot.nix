{
  # foot: lightweight native Wayland terminal, run as a server so that
  # footclient instances spawn near-instantly inside dwl.
  # Font and colours are intentionally left to stylix (../../core/stylix.nix).
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main.pad = "8x8";
      scrollback.lines = 10000;
      mouse.hide-when-typing = "yes";
    };
  };
}
