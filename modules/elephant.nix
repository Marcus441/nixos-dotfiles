_: {
  # Walker's data-provider backend: its own daemon and its own config tree,
  # which hyprpaper-picker.nix writes a menu into. The walker flake's module
  # enabled it implicitly; the home-manager module does not, so it is named.
  flake.modules.homeManager.hyprland = [
    {services.elephant.enable = true;}
  ];
}
