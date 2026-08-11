_: {
  flake.modules.homeManager.waybar = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        cpuTemp = pkgs.writeShellScript "waybar-cpu-temp" ''
          # {"text": "<icon> 47°C", "tooltip": ..., "class": normal|warning|critical}
          sensor=""
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
          [ -r "$sensor" ] || exit 0

          temp=$(( $(<"$sensor") / 1000 ))

          if   [ "$temp" -ge 90 ]; then class=critical; icon=󱗗
          elif [ "$temp" -ge 75 ]; then class=warning;  icon=󱃂
          elif [ "$temp" -ge 55 ]; then class=normal;   icon=󰔏
          else                          class=normal;   icon=󱃃
          fi

          echo "{\"text\": \"$icon ''${temp}°C\", \"tooltip\": \"CPU ''${temp}°C ($label)\", \"class\": \"$class\"}"
        '';
      in {
        programs.waybar.settings.mainBar = {
          cpu =
            {
              interval = 5;
              format = "󰍛 {usage}%";
              states = {
                warning = 80;
                critical = 95;
              };
            }
            // lib.optionalAttrs (config.systemMonitor.command != "") {
              on-click = "uwsm app -- ${config.systemMonitor.command}";
            };

          "custom/cputemp" =
            {
              format = "{}";
              return-type = "json";
              exec = "${cpuTemp}";
              interval = 5;
            }
            // lib.optionalAttrs (config.systemMonitor.command != "") {
              on-click = "uwsm app -- ${config.systemMonitor.command}";
            };

          memory =
            {
              interval = 5;
              format = " {used:0.1f}G";
              tooltip-format = "{used:0.1f}G of {total:0.1f}G used ({percentage}%)";
              states = {
                warning = 80;
                critical = 90;
              };
            }
            // lib.optionalAttrs (config.systemMonitor.memoryCommand != "") {
              on-click = "uwsm app -- ${config.systemMonitor.memoryCommand}";
            };
        };
      }
    )
  ];
}
