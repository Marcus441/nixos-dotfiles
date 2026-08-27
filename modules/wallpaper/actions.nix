_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: let
        action = description:
          lib.mkOption {
            type = lib.types.str;
            default = "";
            inherit description;
          };
      in {
        options.wallpaper = {
          set = action "Command that sets the wallpaper from the image path it is given. Empty when no aspect provides one.";
          enableRotator = action "Command that starts automatic wallpaper rotation, scoped to the category named by an optional first argument. Empty when no aspect provides one.";
          disableRotator = action "Command that stops automatic wallpaper rotation. Empty when no aspect provides one.";
          directory = action "Directory the pickers enumerate for wallpaper images. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    (
      {
        pkgs,
        config,
        ...
      }: let
        walls = import ./_wallpapers.nix {inherit pkgs;};
        cache = config.xdg.cacheHome;
      in {
        wallpaper = {
          directory = "${walls}";
          set = "${pkgs.writeShellScript "set-wallpaper" ''
            [ -f "$1" ] || exit 1
            ${pkgs.coreutils}/bin/rm -f "${cache}/wallpaper_rotator_enabled"
            ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
            ${pkgs.coreutils}/bin/ln -sf "$1" "${cache}/current_wallpaper.img"
            ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$1"
            ${pkgs.libnotify}/bin/notify-send -u low -i media-playback-stop "Wallpaper" "$(${pkgs.coreutils}/bin/basename "$1")"
          ''}";
          enableRotator = "${pkgs.writeShellScript "enable-rotator" ''
            ${pkgs.coreutils}/bin/printf '%s' "''${1-}" >"${cache}/wallpaper_rotator_enabled"
            ${pkgs.systemd}/bin/systemctl --user restart wallpaper-rotator.service
            ${pkgs.libnotify}/bin/notify-send -u low -i media-playlist-shuffle "Wallpaper Rotator" "Automatic rotation enabled''${1:+ ($1)}"
          ''}";
          disableRotator = "${pkgs.writeShellScript "disable-rotator" ''
            ${pkgs.coreutils}/bin/rm -f "${cache}/wallpaper_rotator_enabled"
            ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
            ${pkgs.libnotify}/bin/notify-send -u low -i media-playback-stop "Wallpaper Rotator" "Automatic rotation disabled"
          ''}";
        };
      }
    )
  ];
}
