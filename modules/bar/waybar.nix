_: {
  # The bar reads hyprland/window and hyprland/workspaces, shells out to
  # hyprctl, and binds a systemd target only uwsm-under-Hyprland creates. Made
  # explicit so a dwl host is rejected rather than handed three dead modules;
  # lifting it is a session rework, not a rename.
  aspectRequires.waybar = ["hyprland"];

  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.bar.toggle = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that shows or hides the bar. Empty when no aspect provides an external one; a compositor with a built-in bar toggles it itself.";
        };
      }
    )
  ];

  flake.modules.homeManager.waybar = [
    (
      {
        config,
        lib,
        ...
      }: let
        # Omitted rather than rendered empty: without a power menu the button
        # would open nothing, and without a locker the right-click would do
        # nothing.
        powerModule = lib.optionalAttrs (config.powerMenu.command != "") {
          "custom/power" =
            {
              format = "󰤆";
              tooltip = false;
              on-click = "uwsm app -- ${config.powerMenu.command}";
            }
            // lib.optionalAttrs (config.lock.command != "") {
              on-click-right = config.lock.command;
            };
        };
      in {
        bar.toggle = "systemctl --user is-active --quiet waybar && systemctl --user stop waybar || systemctl --user start waybar";

        programs.waybar = {
          enable = true;
          systemd = {
            enable = true;
            targets = ["wayland-session@hyprland.desktop.target"];
          };
          settings = {
            mainBar =
              {
                layer = "top";
                spacing = 0;
                position = "top";
                height = 26;

                modules-left = [
                  "custom/weather"
                  "hyprland/window"
                ];
                modules-center = [
                  "hyprland/workspaces"
                ];
                modules-right =
                  [
                    "tray"
                    "battery"
                    "bluetooth"
                    "network"
                    "pulseaudio"
                    "clock"
                  ]
                  ++ lib.optional (config.powerMenu.command != "") "custom/power";

                "hyprland/window" = {
                  format = "{title}";
                  max-length = 30;
                  separate-outputs = true;
                };
                "hyprland/workspaces" = {
                  on-click = "activate";
                  disable-scroll = true;
                  all-outputs = true;
                  warp-on-scroll = false;
                  format = "{name}";
                  persistent-workspaces = {
                    "1" = [];
                    "2" = [];
                    "3" = [];
                    "4" = [];
                    "5" = [];
                  };
                };

                clock = {
                  format = "{:%A %H:%M}";
                  format-alt = "{:%d/%m/%Y}";
                  tooltip = false;
                };

                bluetooth = {
                  format = "󰂯";
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

                network =
                  {
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
                  }
                  # Omitted rather than rendered empty, as with the power
                  # button: without a provider the click would open nothing.
                  // lib.optionalAttrs (config.networkManager.command != "") {
                    on-click = "uwsm app -- ${config.networkManager.command}";
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

                pulseaudio = {
                  format = "{icon}";
                  format-bluetooth = "󰂰";
                  format-muted = "";
                  format-icons = {
                    headphone = "";
                    headset = "";
                    default = ["" "" ""];
                  };
                  on-click = "uwsm app -- pavucontrol";
                  on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                  tooltip-format = "Playing at {volume}%";
                  scroll-step = 5;
                };

                tray = {
                  icon-size = 12;
                  spacing = 17;
                };
              }
              // powerModule;
          };
        };
      }
    )
  ];
}
