{lib, ...}: {
  # base16 "Kanagawa Dragon" palette for the lean branch (the suckless profile
  # carries no stylix, so the theme is defined explicitly here). Consumed by
  # ./bash.nix for coloured man pages; available to any other suckless module.
  options.suckless.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    description = "base16 colour palette (hex, with leading '#') for the suckless profile.";
  };

  config.suckless.colors = {
    base00 = "#181616"; # background
    base01 = "#282727"; # lighter background (status bars)
    base02 = "#393836"; # selection background
    base03 = "#625e5a"; # comments, line highlight
    base04 = "#a6a69c"; # dark foreground
    base05 = "#c5c9c5"; # default foreground
    base06 = "#c8c093"; # light foreground
    base07 = "#c5c9c5"; # light background
    base08 = "#c4746e"; # red
    base09 = "#b6927b"; # orange
    base0A = "#c4b28a"; # yellow
    base0B = "#8a9a7b"; # green
    base0C = "#8ea4a2"; # cyan / aqua
    base0D = "#8ba4b0"; # blue
    base0E = "#a292a3"; # magenta / violet
    base0F = "#b98d7b"; # brown / special
  };
}
