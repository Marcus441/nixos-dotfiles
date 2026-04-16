{
  imports = [
    ./scripts.nix
    ./style.nix
  ];
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = ["wayland-session@hyprland.desktop.target"];
    };
    settings = {
      mainBar = {
        layer = "top";
        spacing = 0;
        position = "top";
        height = 26;

        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "custom/weather"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "disk"
          "battery"
          "backlight"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          on-click = "activate";
          disable-scroll = true;
          all-outputs = true;
          warp-on-scroll = false;
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "active" = "󱓻";
            "default" = "";
          };
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "custom/weather" = {
          format = "{}";
          return-type = "json";
          exec = "$HOME/.config/waybar/scripts/weather.sh";
          interval = 60;
        };

        clock = {
          format = "{:%A %H:%M}";
          format-alt = "{:%d %B W%V %Y}";
          tooltip = false;
        };

        bluetooth = {
          format = "";
          format-off = "󰂲";
          format-disabled = "󰂲";
          format-connected = "󰂱";
          format-no-controller = "";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "uwsm app -- blueman-manager";
        };

        network = {
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format = "{icon}";
          format-wifi = "{icon}";
          format-ethernet = "󱘖";
          format-linked = "󰤮";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({signalStrength}%) {frequency}GHz\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "{ifname} 󱘖\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          spacing = 1;
          on-click = "hyprctl dispatch exec \"[float; size 1200 800] ghostty -e nmtui\"";
        };

        battery = {
          interval = 5;
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon}";
          format-discharging = "{icon}";
          format-charging = "{icon}";
          format-plugged = "";
          format-full = "󰂅";
          format-icons = {
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          tooltip-format-discharging = "{power:>1.0f}W↓ {capacity}%";
          tooltip-format-charging = "{power:>1.0f}W↑ {capacity}%";
        };

        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          format-icons = ["" "" "" "" "" "" "" "" "" ""];
          on-scroll-down = "light -A 10";
          on-scroll-up = "light -U 10";
          smooth-scrolling-threshold = 1;
        };

        disk = {
          interval = 300;
          format = "󰋊";
          tooltip-format = "{percentage_used}% used";
          path = "/";
        };

        cpu = {
          interval = 5;
          format = "󰍛";
          tooltip-format = "{usage}%";
          on-click = "hyprctl dispatch exec \"[float; size 1200 800] ghostty -e btop\"";
        };

        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "󰂰";
          format-muted = "";
          format-icons = {
            headphone = "";
            headset = "";
            default = ["" "" ""];
          };
          on-click = "uwsm app -- pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          tooltip-format = "Playing at {volume}%";
          scroll-step = 5;
        };

        "custom/launcher" = {
          format = "<span size='14000'>󱗼</span>";
          tooltip = false;
          on-click = "walker";
        };

        "custom/power" = {
          format = "󰤆";
          tooltip = false;
          on-click = "hyprlock";
          on-click-right = "uwsm app -- wlogout";
        };

        tray = {
          icon-size = 12;
          spacing = 17;
        };
      };
    };
  };
}
