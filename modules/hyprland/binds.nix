_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        lib,
        config,
        pkgs,
        ...
      }: let
        mainMod = "SUPER";
        terminal = "uwsm app -- ${config.terminal.command}";
        terminalFallback = "uwsm app -- ${config.terminal.fallbackCommand}";
        # load-bearing: docs/decisions/sessions.md#monocle-visual-profile
        hyprCfg = config.wayland.windowManager.hyprland.settings.config;
        # load-bearing: docs/decisions/sessions.md#layout-state-file
        layoutSet = pkgs.writeShellScript "layout-set" ''
          case "$1" in
            monocle)
              ${pkgs.hyprland}/bin/hyprctl eval "hl.config({ general = { layout = \"monocle\", gaps_in = 0, gaps_out = 0, border_size = 0 }, animations = { enabled = false } })"
              ;;
            *)
              ${pkgs.hyprland}/bin/hyprctl eval "hl.config({ general = { layout = \"$1\", gaps_in = ${builtins.toJSON hyprCfg.general.gaps_in}, gaps_out = ${builtins.toJSON hyprCfg.general.gaps_out}, border_size = ${builtins.toJSON hyprCfg.general.border_size} }, animations = { enabled = ${builtins.toJSON hyprCfg.animations.enabled} } })"
              ;;
          esac
          CACHE="''${XDG_CACHE_HOME:-$HOME/.cache}"
          mkdir -p "$CACHE"
          printf '%s\n' "$1" >"$CACHE/hyprland-layout"
        '';
        layoutToggle = pkgs.writeShellScript "layout-toggle" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${layoutSet} dwindle ;;
            *) exec ${layoutSet} monocle ;;
          esac
        '';
        cycleNext = pkgs.writeShellScript "cycle-next" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.layout("cyclenext")' ;;
            *) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.window.cycle_next()' ;;
          esac
        '';
        focusLeft = pkgs.writeShellScript "focus-left" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ workspace = "m-1" })' ;;
            *) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ direction = "l" })' ;;
          esac
        '';
        focusRight = pkgs.writeShellScript "focus-right" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ workspace = "m+1" })' ;;
            *) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ direction = "r" })' ;;
          esac
        '';
        focusUp = pkgs.writeShellScript "focus-up" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.layout("cycleprev")' ;;
            *) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ direction = "u" })' ;;
          esac
        '';
        focusDown = pkgs.writeShellScript "focus-down" ''
          case "$(${pkgs.hyprland}/bin/hyprctl getoption general:layout)" in
            *monocle*) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.layout("cyclenext")' ;;
            *) exec ${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.focus({ direction = "d" })' ;;
          esac
        '';
      in {
        wayland.windowManager.hyprland.settings.bind =
          [
            {
              _args = [
                "${mainMod} + SHIFT + C"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- hyprpicker -an\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + S"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.screenshot.screen}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + Z"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm stop\")")
              ];
            }
          ]
          ++ lib.optionals (config.bar.toggle != "") [
            {
              _args = [
                "${mainMod} + B"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.bar.toggle}\")")
              ];
            }
          ]
          ++ [
            {
              _args = [
                "${mainMod} + C"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ocr-copy\")")
              ];
            }
            {
              _args = [
                "${mainMod} + D"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launcher.command}\")")
              ];
            }
          ]
          ++ lib.optionals (config.fileManager.command != "") [
            {
              _args = [
                "${mainMod} + E"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${config.fileManager.command}\")")
              ];
            }
          ]
          ++ [
            {
              _args = [
                "${mainMod} + F"
                (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + Q"
                (lib.generators.mkLuaInline "hl.dsp.window.close()")
              ];
            }
            {
              _args = [
                "${mainMod} + Return"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${terminal}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + Return"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${terminalFallback}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + S"
                (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
              ];
            }
            {
              _args = [
                "${mainMod} + P"
                (lib.generators.mkLuaInline "hl.dsp.window.pseudo()")
              ];
            }
            {
              _args = [
                "${mainMod} + M"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${layoutSet} monocle\")")
              ];
            }
            {
              _args = [
                "${mainMod} + T"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${layoutSet} dwindle\")")
              ];
            }
            {
              _args = [
                "${mainMod} + space"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${layoutToggle}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + Tab"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${cycleNext}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + V"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.clipboard.history}\")")
              ];
            }
          ]
          ++ lib.optionals (config.wallpaperMenu.command != "") [
            {
              _args = [
                "${mainMod} + W"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.wallpaperMenu.command}\")")
              ];
            }
          ]
          ++ lib.optionals (config.powerMenu.command != "") [
            {
              _args = [
                "${mainMod} + Z"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ${config.powerMenu.command}\")")
              ];
            }
          ]
          ++ [
            {
              _args = [
                "Print"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.screenshot.area}\")")
              ];
            }

            {
              _args = [
                "${mainMod} + H"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${focusLeft}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + L"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${focusRight}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + K"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${focusUp}\")")
              ];
            }
            {
              _args = [
                "${mainMod} + J"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${focusDown}\")")
              ];
            }

            {
              _args = [
                "${mainMod} + SHIFT + H"
                (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"l\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + L"
                (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"r\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + K"
                (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"u\" })")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + J"
                (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"d\" })")
              ];
            }

            {_args = ["${mainMod} + 1" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")];}
            {_args = ["${mainMod} + 2" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")];}
            {_args = ["${mainMod} + 3" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")];}
            {_args = ["${mainMod} + 4" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")];}
            {_args = ["${mainMod} + 5" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")];}
            {_args = ["${mainMod} + 6" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")];}
            {_args = ["${mainMod} + 7" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")];}
            {_args = ["${mainMod} + 8" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")];}
            {_args = ["${mainMod} + 9" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")];}

            {_args = ["${mainMod} + SHIFT + 1" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")];}
            {_args = ["${mainMod} + SHIFT + 2" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")];}
            {_args = ["${mainMod} + SHIFT + 3" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")];}
            {_args = ["${mainMod} + SHIFT + 4" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")];}
            {_args = ["${mainMod} + SHIFT + 5" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")];}
            {_args = ["${mainMod} + SHIFT + 6" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")];}
            {_args = ["${mainMod} + SHIFT + 7" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")];}
            {_args = ["${mainMod} + SHIFT + 8" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")];}
            {_args = ["${mainMod} + SHIFT + 9" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")];}

            {
              _args = [
                "${mainMod} + 0"
                (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special(\"magic\")")
              ];
            }
            {
              _args = [
                "${mainMod} + SHIFT + 0"
                (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"special:magic\" })")
              ];
            }

            {
              _args = [
                "${mainMod} + mouse:272"
                (lib.generators.mkLuaInline "hl.dsp.window.drag()")
                {mouse = true;}
              ];
            }
            {
              _args = [
                "${mainMod} + mouse:273"
                (lib.generators.mkLuaInline "hl.dsp.window.resize()")
                {mouse = true;}
              ];
            }

            {
              _args = [
                "XF86AudioRaiseVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioMicMute"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }
            {
              _args = [
                "${mainMod} + bracketright"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%+\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }
            {
              _args = [
                "${mainMod} + bracketleft"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%-\")")
                {
                  repeating = true;
                  locked = true;
                }
              ];
            }

            {
              _args = [
                "XF86AudioNext"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl next\")")
                {locked = true;}
              ];
            }
            {
              _args = [
                "XF86AudioPause"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
                {locked = true;}
              ];
            }
            {
              _args = [
                "XF86AudioPlay"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl play-pause\")")
                {locked = true;}
              ];
            }
            {
              _args = [
                "XF86AudioPrev"
                (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"playerctl previous\")")
                {locked = true;}
              ];
            }
          ];
      }
    )
  ];
}
