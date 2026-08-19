_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        lib,
        config,
        pkgs,
        ...
      }: let
        inherit (lib.generators) mkLuaInline;
        bind = keys: dsp: {_args = [keys (mkLuaInline dsp)];};
        bindOpts = keys: dsp: opts: {_args = [keys (mkLuaInline dsp) opts];};
        exec = keys: cmd: bind keys ''hl.dsp.exec_cmd("${cmd}")'';
        execOpts = keys: cmd: opts: bindOpts keys ''hl.dsp.exec_cmd("${cmd}")'' opts;
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
            (exec "${mainMod} + SHIFT + C" "uwsm app -- hyprpicker -an")
            (exec "${mainMod} + SHIFT + S" config.screenshot.screen)
            (exec "${mainMod} + SHIFT + Z" "uwsm stop")
          ]
          ++ lib.optionals (config.bar.toggle != "") [
            (exec "${mainMod} + B" config.bar.toggle)
          ]
          ++ [
            (exec "${mainMod} + C" "uwsm app -- ocr-copy")
            (exec "${mainMod} + D" config.launcher.command)
          ]
          ++ lib.optionals (config.fileManager.command != "") [
            (exec "${mainMod} + E" "uwsm app -- ${config.fileManager.command}")
          ]
          ++ [
            (bind "${mainMod} + F" ''hl.dsp.window.float({ action = "toggle" })'')
            (bind "${mainMod} + Q" "hl.dsp.window.close()")
            (exec "${mainMod} + Return" terminal)
            (exec "${mainMod} + SHIFT + Return" terminalFallback)
            (bind "${mainMod} + S" ''hl.dsp.layout("togglesplit")'')
            (bind "${mainMod} + P" "hl.dsp.window.pseudo()")
            (exec "${mainMod} + M" "${layoutSet} monocle")
            (exec "${mainMod} + T" "${layoutSet} dwindle")
            (exec "${mainMod} + space" "${layoutToggle}")
            (exec "${mainMod} + Tab" "${cycleNext}")
            (exec "${mainMod} + V" config.clipboard.history)
          ]
          ++ lib.optionals (config.wallpaperMenu.command != "") [
            (exec "${mainMod} + W" config.wallpaperMenu.command)
          ]
          ++ lib.optionals (config.powerMenu.command != "") [
            (exec "${mainMod} + Z" config.powerMenu.command)
          ]
          ++ [
            (exec "Print" config.screenshot.area)

            (exec "${mainMod} + H" "${focusLeft}")
            (exec "${mainMod} + L" "${focusRight}")
            (exec "${mainMod} + K" "${focusUp}")
            (exec "${mainMod} + J" "${focusDown}")

            (bind "${mainMod} + SHIFT + H" ''hl.dsp.window.swap({ direction = "l" })'')
            (bind "${mainMod} + SHIFT + L" ''hl.dsp.window.swap({ direction = "r" })'')
            (bind "${mainMod} + SHIFT + K" ''hl.dsp.window.swap({ direction = "u" })'')
            (bind "${mainMod} + SHIFT + J" ''hl.dsp.window.swap({ direction = "d" })'')
          ]
          ++ map (i: bind "${mainMod} + ${toString i}" "hl.dsp.focus({ workspace = ${toString i} })") (lib.range 1 9)
          ++ map (i: bind "${mainMod} + SHIFT + ${toString i}" "hl.dsp.window.move({ workspace = ${toString i} })") (lib.range 1 9)
          ++ [
            (bind "${mainMod} + 0" ''hl.dsp.workspace.toggle_special("magic")'')
            (bind "${mainMod} + SHIFT + 0" ''hl.dsp.window.move({ workspace = "special:magic" })'')

            (bindOpts "${mainMod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
            (bindOpts "${mainMod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

            (execOpts "XF86AudioRaiseVolume" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+" {
              repeating = true;
              locked = true;
            })
            (execOpts "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" {
              repeating = true;
              locked = true;
            })
            (execOpts "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" {
              repeating = true;
              locked = true;
            })
            (execOpts "XF86AudioMicMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" {
              repeating = true;
              locked = true;
            })
            (execOpts "${mainMod} + bracketright" "brightnessctl s 10%+" {
              repeating = true;
              locked = true;
            })
            (execOpts "${mainMod} + bracketleft" "brightnessctl s 10%-" {
              repeating = true;
              locked = true;
            })

            (execOpts "XF86AudioNext" "playerctl next" {locked = true;})
            (execOpts "XF86AudioPause" "playerctl play-pause" {locked = true;})
            (execOpts "XF86AudioPlay" "playerctl play-pause" {locked = true;})
            (execOpts "XF86AudioPrev" "playerctl previous" {locked = true;})
          ];
      }
    )
  ];
}
