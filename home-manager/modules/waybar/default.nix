{
  imports = [
    ./scripts.nix
  ];
  programs.waybar = {
    enable = true;
    style = ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;

        modules-left = [
          "custom/logo"
          "clock"
          "custom/weather"
          "disk"
          "memory"
          "cpu"
          "temperature"
          "custom/powerDraw"
        ];
        modules-center = ["hyprland/workspaces"];
        modules-right = [
          "group/tray-expander"
          "bluetooth"
          "network"
          "battery"
          "backlight"
          "pulseaudio"
          "idle_inhibitor"
        ];

        "custom/logo" = {
          format = " ";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "active" = "";
            "default" = "";
          };
          persistent-workspaces = {
            "*" = [2 3 4 5 6];
          };
        };

        idle_inhibitor = {
          format = "<span font='12'>{icon} </span>";
          format-icons = {
            activated = "󰈈 ";
            deactivated = "󰈉 ";
          };
        };

        "custom/weather" = {
          format = "{}";
          return-type = "json";
          exec = "$HOME/.config/waybar/scripts/weather.sh";
          interval = 10;
        };

        clock = {
          format = "{:%I:%M:%S %p}";
          interval = 1;
          tooltip-format = "\n<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar-weeks-pos = "right";
          today-format = "<span color='#7645AD'><b><u>{}</u></b></span>";
          format-calendar = "<span color='#aeaeae'><b>{}</b></span>";
          format-calendar-weeks = "<span color='#aeaeae'><b>W{:%V}</b></span>";
          format-calendar-weekdays = "<span color='#aeaeae'><b>{}</b></span>";
        };

        bluetooth = {
          format-on = "";
          format-off = "";
          format-disabled = "󰂲";
          format-connected = "󰂴";
          format-connected-battery = "{device_battery_percentage}% 󰂴";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        network = {
          format-wifi = " ";
          format-ethernet = " ";
          format-disconnected = " ";
          tooltip-format = "{ipaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  | {ipaddr}";
          tooltip-format-ethernet = "{ifname} 🖧 | {ipaddr}";
          on-click = "networkmanager_dmenu";
        };

        battery = {
          interval = 1;
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{capacity}%  {icon}";
          format-charging = "{capacity}% 󰂄";
          format-plugged = "{capacity}% 󰂄 ";
          format-alt = "{time} {icon}";
          format-icons = [
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
        };

        backlight = {
          device = "intel_backlight";
          format = "<span font='12'>{icon}</span>";
          format-icons = ["" "" "" "" "" "" "" "" "" ""];
          on-scroll-down = "light -A 10";
          on-scroll-up = "light -U 10";
          smooth-scrolling-threshold = 1;
        };

        disk = {
          interval = 30;
          format = " {percentage_used}%";
          path = "/";
        };

        cpu = {
          interval = 1;
          format = "  {usage}%";
          min-length = 6;
          max-length = 6;
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        };

        memory = {format = "  {percentage}%";};

        temperature = {
          format = " {temperatureC}°C";
          format-critical = " {temperatureC}°C";
          interval = 1;
          critical-threshold = 80;
          on-click = "ghostty --gtk-single-instance=true -e btm";
        };

        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "󰂰";
          format-muted = "<span font=''> </span>";
          format-icons = {
            headphones = "";
            bluetooth = "󰥰";
            handsfree = "";
            headset = "󱡬";
            phone = "";
            portable = "";
            car = "";
            default = [" " " " " "];
          };
          justify = "center";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click = "pavucontrol";
          tooltip-format = "{icon}  {volume}%";
        };

        jack = {
          format = "{} 󱎔";
          format-xrun = "{xruns} xruns";
          format-disconnected = "DSP off";
          realtime = true;
        };

        "group/tray-expander" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 600;
            children-class = "tray-group-item";
          };
          modules = ["custom/expand-icon" "tray"];
        };
        "custom/expand-icon" = {
          format = " ";
          tooltip = false;
        };
        tray = {
          icon-size = 14;
          spacing = 10;
        };

        upower = {
          show-icon = false;
          hide-if-empty = true;
          tooltip = true;
          tooltip-spacing = 20;
        };

        "custom/powerDraw" = {
          format = "{}";
          interval = 1;
          exec = "$HOME/.config/waybar/scripts/powerdraw.sh";
          return-type = "json";
        };
      };
    };
  };
}
