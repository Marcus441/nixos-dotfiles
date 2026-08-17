{
  pkgs,
  colors,
  font,
  barPosition,
  lockCommand,
  logoutCommand,
  systemMonitorCommand,
  processorCommand,
  memoryCommand,
  temperatureCommand,
  networkManagerCommand,
}: let
  inherit (pkgs) lib;
  qml = lib.replaceStrings ["\\" "\""] ["\\\\" "\\\""];
  walls = import ../wallpaper/_wallpapers.nix {inherit pkgs;};

  setWallpaper = pkgs.writeShellScript "qs-set-wallpaper" ''
    [ -f "$1" ] || exit 1
    CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}"
    rm -f "$CACHE/wallpaper_rotator_enabled"
    ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
    ln -sf "$1" "$CACHE/current_wallpaper.img"
    ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ",$1"
    ${pkgs.libnotify}/bin/notify-send -u low -i media-playback-stop "Wallpaper" "$(basename "$1")"
  '';

  enableRotator = pkgs.writeShellScript "qs-enable-rotator" ''
    CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}"
    touch "$CACHE/wallpaper_rotator_enabled"
    ${pkgs.systemd}/bin/systemctl --user start wallpaper-rotator.service
    ${pkgs.libnotify}/bin/notify-send -u low -i media-playlist-shuffle "Wallpaper Rotator" "Automatic rotation enabled"
  '';

  disableRotator = pkgs.writeShellScript "qs-disable-rotator" ''
    CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}"
    rm -f "$CACHE/wallpaper_rotator_enabled"
    ${pkgs.systemd}/bin/systemctl --user stop wallpaper-rotator.service
    ${pkgs.libnotify}/bin/notify-send -u low -i media-playback-stop "Wallpaper Rotator" "Automatic rotation disabled"
  '';

  metrics = pkgs.writeShellScript "qs-metrics" ''
    read -r total idle <<<"$(${pkgs.gawk}/bin/awk '/^cpu /{print $2+$3+$4+$5+$6+$7+$8, $5}' /proc/stat)"
    sensor="" label=""
    for chip in /sys/class/hwmon/hwmon*; do
      [ -r "$chip/name" ] || continue
      case "$(<"$chip/name")" in
        k10temp | zenpower | coretemp)
          sensor="$chip/temp1_input"
          label="$(<"$chip/name")"
          break
          ;;
      esac
    done
    if [ ! -r "$sensor" ]; then
      sensor=/sys/class/thermal/thermal_zone0/temp
      label=thermal_zone0
    fi
    temp=0
    [ -r "$sensor" ] && temp=$(($(<"$sensor") / 1000))
    read -r memUsed memTotal <<<"$(${pkgs.gawk}/bin/awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%.1f %.1f", (t-a)/1048576, t/1048576}' /proc/meminfo)"
    diskPct=$(${pkgs.coreutils}/bin/df --output=pcent / | ${pkgs.coreutils}/bin/tail -1 | ${pkgs.coreutils}/bin/tr -dc 0-9)
    printf '{"total":%s,"idle":%s,"tempC":%s,"tempChip":"%s","memUsed":%s,"memTotal":%s,"diskPct":%s}\n' \
      "$total" "$idle" "$temp" "$label" "$memUsed" "$memTotal" "''${diskPct:-0}"
  '';

  colorProps =
    lib.concatStrings
    (lib.mapAttrsToList
      (name: value: "    readonly property color ${name}: \"${value}\"\n")
      colors);

  configQml = pkgs.writeText "quickshell-Config.qml" ''
    pragma Singleton
    import Quickshell
    import QtQuick

    Singleton {
        id: root

    ${colorProps}
        readonly property string fontFamily: "Inter"
        readonly property string monoFamily: "${qml font.name}"
        readonly property string iconFamily: "Symbols Nerd Font Mono"
        readonly property int fontSize: 12
        readonly property string barPosition: "${barPosition}"

        readonly property real weatherLat: -27.4705
        readonly property real weatherLon: 153.0260
        readonly property string weatherTimezone: "Australia/Brisbane"

        readonly property string lockCommand: "${qml lockCommand}"
        readonly property string logoutCommand: "${qml logoutCommand}"
        readonly property string systemMonitorCommand: "${qml systemMonitorCommand}"
        readonly property string processorCommand: "${qml processorCommand}"
        readonly property string memoryCommand: "${qml memoryCommand}"
        readonly property string temperatureCommand: "${qml temperatureCommand}"
        readonly property string networkManagerCommand: "${qml networkManagerCommand}"

        readonly property string wallsDir: "${walls}"
        readonly property string setWallpaperScript: "${setWallpaper}"
        readonly property string enableRotatorScript: "${enableRotator}"
        readonly property string disableRotatorScript: "${disableRotator}"
        readonly property string metricsScript: "${metrics}"
        readonly property string sh: "${pkgs.runtimeShell}"
        readonly property string systemctl: "${pkgs.systemd}/bin/systemctl"
        readonly property string hyprctl: "${pkgs.hyprland}/bin/hyprctl"
        readonly property string curl: "${pkgs.curl}/bin/curl"
        readonly property string fd: "${pkgs.fd}/bin/fd"
        readonly property string cliphist: "${pkgs.cliphist}/bin/cliphist"
        readonly property string wlCopy: "${pkgs.wl-clipboard}/bin/wl-copy"

        function launch(cmd: string): void {
            Quickshell.execDetached([root.sh, "-c", cmd]);
        }

        function launchApp(cmd: string): void {
            root.launch(`uwsm app -- ''${cmd}`);
        }
    }
  '';
in
  pkgs.runCommand "quickshell-default-config" {} ''
    mkdir -p $out
    cp -r --no-preserve=mode ${./_qml}/. $out/
    cp ${configQml} $out/Config.qml
  ''
