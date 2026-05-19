{
  xdg.configFile."uwsm/env".text = ''
    export NIXOS_OZONE_WL=1
    export QT_QPA_PLATFORM=wayland
  '';
}
