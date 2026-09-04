_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        lib,
        config,
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
      in {
        wayland.windowManager.hyprland = {
          # load-bearing: docs/decisions/sessions.md#monocle-visual-profile
          # load-bearing: docs/decisions/sessions.md#layout-event
          extraLuaFiles.layout = ./_layout.lua;

          settings.layout = {_var = mkLuaInline ''require("layout")'';};

          settings.bind =
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
            ]
            ++ lib.optionals (config.launcher.command != "") [
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
              (bind "${mainMod} + S" "layout.togglesplit")
              (bind "${mainMod} + P" "hl.dsp.window.pseudo()")
              (bind "${mainMod} + M" ''layout.set("monocle")'')
              (bind "${mainMod} + T" ''layout.set("dwindle")'')
              (bind "${mainMod} + space" "layout.toggle")
              (bind "${mainMod} + SHIFT + Tab" "layout.cycle_next")
            ]
            ++ lib.optionals (config.switcher.command != "") [
              (exec "${mainMod} + Tab" config.switcher.command)
            ]
            ++ lib.optionals (config.clipboard.history != "") [
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

              (bind "${mainMod} + H" ''layout.focus("l")'')
              (bind "${mainMod} + L" ''layout.focus("r")'')
              (bind "${mainMod} + K" ''layout.focus("u")'')
              (bind "${mainMod} + J" ''layout.focus("d")'')

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
            ]
            # load-bearing: docs/decisions/audio.md#media-keys-ipc
            ++ lib.optionals (config.media.next != "") [
              (execOpts "XF86AudioNext" config.media.next {locked = true;})
            ]
            ++ lib.optionals (config.media.playPause != "") [
              (execOpts "XF86AudioPause" config.media.playPause {locked = true;})
              (execOpts "XF86AudioPlay" config.media.playPause {locked = true;})
            ]
            ++ lib.optionals (config.media.previous != "") [
              (execOpts "XF86AudioPrev" config.media.previous {locked = true;})
            ];
        };
      }
    )
  ];
}
