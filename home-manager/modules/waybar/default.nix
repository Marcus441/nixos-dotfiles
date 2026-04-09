{config, ...}: {
  imports = [
    ./scripts.nix
    ./style.nix
  ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        spacing = 4;
        position = "top";
        height = 30;

        modules-left = [
          "custom/launcher"
          "custom/spacer"
          "hyprland/workspaces"
          "custom/spacer"
          "custom/weather"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "custom/kernel"
          "cpu"
          "memory"
          "disk"
          "bluetooth"
          "network"
          "battery"
          "backlight"
          "pulseaudio"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{name}: {icon}";
          format-icons = {
            "1" = "";
            "2" = "󰇮";
            "3" = "";
            "4" = "";
            "5" = "󰭹";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = [1 2 3 4 5];
          };
        };

        "custom/weather" = {
          format = "{}";
          return-type = "json";
          exec = "$HOME/.config/waybar/scripts/weather.sh";
          interval = 60;
        };

        clock = {
          format = "{:%a, %b %d - %I:%M %p}";
          format-alt = "{:%a, %b %d %Y}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        bluetooth = {
          format-on = "󰂯";
          format-off = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-connected-battery = "{device_battery_percentage}% 󰂴";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "uwsm app -- blueman-manager";
        };

        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-wifi = "{icon}";
          format-ethernet = "󱘖";

          format-linked = "󰤮 {ifname} (No IP)";

          format-disconnected = "󰤮";

          tooltip-format-wifi = "{essid} ({signalStrength}%) {frequency}GHz\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "{ifname} 󱘖\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";

          interval = 3;
          spacing = 1;
          on-click = "hyprctl dispatch exec \"[float; size 1200 800] uwsm app -- ghostty -e nmtui\"";
        };

        battery = {
          interval = 1;
          states = {
            warning = 30;
            critical = 20;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰂄 ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" "" ""];
          on-scroll-down = "light -A 10";
          on-scroll-up = "light -U 10";
          smooth-scrolling-threshold = 1;
        };

        disk = {
          interval = 300;
          format = "󰋊 {percentage_used}%";
          path = "/";
        };

        cpu = {
          interval = 1;
          format = "󰘚 {usage}%";
          on-click = "hyprctl dispatch exec \"[float; size 1200 800] uwsm app -- ghostty -e btop\"";
        };

        memory = {
          interval = 5;
          format = "󰍛 {percentage}%";
          on-click = "hyprctl dispatch exec \"[float; size 1200 800] uwsm app -- ghostty -e btop\"";
        };

        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "󰂰";
          format-muted = "󰝟";
          format-icons = {
            headset = "󱡬";
            default = ["󰖀" "󰕾" ""];
          };
          justify = "center";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click = "uwsm app -- pavucontrol";
          tooltip-format = "{icon} {volume}%";
        };

        "custom/launcher" = {
          format = "<span size='14000'>󱗼</span>";
          tooltip = false;
          on-click = "walker";
        };

        "custom/spacer" = {
          format = "  ";
        };

        "custom/kernel" = {
          format = " {}";
          interval = 3600;
          exec = "uname -r | cut -d '-' -f1";
        };

        "custom/power" = {
          format = "󰤆";
          tooltip = false;
          on-click = "hyprlock";
          on-click-right = "uwsm app -- wlogout";
        };

        tray = {
          icon-size = 14;
          spacing = 10;
        };
      };
    };
  };
}
