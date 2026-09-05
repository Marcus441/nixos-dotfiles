{
  pkgs,
  colors,
  roles,
  font,
  barPosition,
  cacheDir,
  lockCommand,
  logoutCommand,
  systemMonitorCommand,
  processorCommand,
  memoryCommand,
  temperatureCommand,
  diskCommand,
  audioMixerCommand,
  weatherLatitude,
  weatherLongitude,
  weatherTimezone,
  wallpaperSet,
  wallpaperEnableRotator,
  wallpaperDisableRotator,
  wallpaperThumbnailManifest,
}: let
  inherit (pkgs) lib;
  qml = lib.replaceStrings ["\\" "\""] ["\\\\" "\\\""];

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
    disks=""
    for blk in /sys/block/*; do
      dev=''${blk##*/}
      case "$dev" in loop* | zram* | ram* | sr* | md* | dm-*) continue ;; esac
      sectors=$(<"$blk/size") || continue
      [ "''${sectors:-0}" -gt 0 ] || continue
      ioMs=$(${pkgs.gawk}/bin/awk -v d="$dev" '$3 == d {print $13; exit}' /proc/diskstats)
      disks="$disks{\"name\":\"$dev\",\"ioMs\":''${ioMs:-0}},"
    done
    mounts=""
    while read -r src blocks used; do
      part=''${src##*/}
      [ -r "/sys/class/block/$part/dev" ] || continue
      node="/sys/dev/block/$(<"/sys/class/block/$part/dev")"
      [ -e "/sys/class/block/$part/partition" ] && node="$node/.."
      name=$(${pkgs.gawk}/bin/awk -F= '/^DEVNAME=/{print $2; exit}' "$node/uevent" 2>/dev/null)
      [ -n "$name" ] && mounts="$mounts{\"dev\":\"$name\",\"blocks\":$blocks,\"used\":$used},"
    done <<EOF
    $(${pkgs.coreutils}/bin/df -l --output=source,size,used 2>/dev/null |
      ${pkgs.gawk}/bin/awk 'NR > 1 && $1 ~ "^/dev/" && !seen[$1]++')
    EOF
    read -r upSec _ < /proc/uptime
    printf '{"total":%s,"idle":%s,"tempC":%s,"tempChip":"%s","memUsed":%s,"memTotal":%s,"upSec":%s,"disks":[%s],"mounts":[%s]}\n' \
      "$total" "$idle" "$temp" "$label" "$memUsed" "$memTotal" "$upSec" "''${disks%,}" "''${mounts%,}"
  '';

  volumeSound = pkgs.writeShellScript "qs-volume-sound" ''
    exec ${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
  '';

  colorProps =
    lib.concatStrings
    (lib.mapAttrsToList
      (name: value: "    readonly property color ${name}: \"${value}\"\n")
      colors);

  roleProps =
    lib.concatStrings
    (lib.mapAttrsToList
      (name: value: "    readonly property color ${name}: \"${value}\"\n")
      roles);

  configQml = pkgs.writeText "quickshell-Config.qml" ''
    pragma Singleton
    import Quickshell
    import QtQuick

    Singleton {
        id: root

    ${colorProps}
    ${roleProps}
        readonly property string fontFamily: "Inter"
        readonly property string monoFamily: "${qml font.name}"
        readonly property string iconFamily: "Symbols Nerd Font Mono"
        readonly property int fontSize: ${toString font.size}
        readonly property string barPosition: "${barPosition}"

        readonly property real weatherLat: ${weatherLatitude}
        readonly property real weatherLon: ${weatherLongitude}
        readonly property string weatherTimezone: "${qml weatherTimezone}"

        readonly property string lockCommand: "${qml lockCommand}"
        readonly property string logoutCommand: "${qml logoutCommand}"
        readonly property string systemMonitorCommand: "${qml systemMonitorCommand}"
        readonly property string processorCommand: "${qml processorCommand}"
        readonly property string memoryCommand: "${qml memoryCommand}"
        readonly property string temperatureCommand: "${qml temperatureCommand}"
        readonly property string diskCommand: "${qml diskCommand}"
        readonly property string audioMixerCommand: "${qml audioMixerCommand}"

        readonly property string cacheDir: "${qml cacheDir}"
        readonly property string wallpaperManifest: "${qml wallpaperThumbnailManifest}"
        readonly property string setWallpaperScript: "${qml wallpaperSet}"
        readonly property string enableRotatorScript: "${qml wallpaperEnableRotator}"
        readonly property string disableRotatorScript: "${qml wallpaperDisableRotator}"
        readonly property string metricsScript: "${metrics}"
        readonly property string volumeSoundScript: "${volumeSound}"
        readonly property string sh: "${pkgs.runtimeShell}"
        readonly property string systemctl: "${pkgs.systemd}/bin/systemctl"
        readonly property string hyprctl: "${pkgs.hyprland}/bin/hyprctl"
        readonly property string curl: "${pkgs.curl}/bin/curl"
        readonly property string cliphist: "${pkgs.cliphist}/bin/cliphist"
        readonly property string wlCopy: "${pkgs.wl-clipboard}/bin/wl-copy"
        readonly property string head: "${pkgs.coreutils}/bin/head"
        readonly property string wc: "${pkgs.coreutils}/bin/wc"

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
