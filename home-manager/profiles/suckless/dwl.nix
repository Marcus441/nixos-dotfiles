{pkgs, ...}: {
  # dwl: the pure Wayland successor to dwm, written in C.
  #
  # Scaffold: stock dwl is configured at build time via config.h, so custom
  # keybinds/layouts will eventually require an override of pkgs.dwl with a
  # patched source. For now we install the stock binary plus the minimal
  # Wayland helpers the lean session relies on. Monitor layout is applied at
  # runtime by the compositor-agnostic `dwl-monitors` script (see ./monitors.nix).
  home.packages = with pkgs; [
    dwl
    bemenu # dmenu-equivalent launcher for the dwl session
  ];
}
