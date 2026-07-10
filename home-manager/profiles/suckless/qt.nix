{...}: {
  # Route Qt apps through a dark Adwaita theme so they match GTK. Qt's Wayland
  # platform is selected separately via QT_QPA_PLATFORM in home.nix.
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
}
