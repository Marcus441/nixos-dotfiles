{lib, ...}: let
  mainMod = "SUPER";
  terminal = "uwsm app -- ghostty";
  fileManager = "uwsm app -- thunar";
in {
  wayland.windowManager.hyprland.settings = {
    bind = [
      # --- General ---
      {
        _args = [
          "${mainMod} + SHIFT + C"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- hyprpicker -an\")")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + S"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- grimblast --notify --freeze copysave screen\")")
        ];
      }
      {
        _args = [
          "${mainMod} + SHIFT + Z"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm stop\")")
        ];
      }
      {
        _args = [
          "${mainMod} + B"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"systemctl --user is-active --quiet waybar && systemctl --user stop waybar || systemctl --user start waybar\")")
        ];
      }
      {
        _args = [
          "${mainMod} + C"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ocr-copy\")")
        ];
      }
      {
        _args = [
          "${mainMod} + D"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker\")")
        ];
      }
      {
        _args = [
          "${mainMod} + E"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${fileManager}\")")
        ];
      }
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
          "${mainMod} + S"
          (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
        ];
      }
      {
        _args = [
          "${mainMod} + Tab"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m windows\")")
        ];
      }
      {
        _args = [
          "${mainMod} + V"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m clipboard\")")
        ];
      }
      {
        _args = [
          "${mainMod} + W"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m menus:wallpapers\")")
        ];
      }
      {
        _args = [
          "${mainMod} + Z"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- wleave\")")
        ];
      }
      {
        _args = [
          "Print"
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- grimblast --notify --freeze copysave area\")")
        ];
      }

      # --- Focus movement ---
      {
        _args = [
          "${mainMod} + H"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + L"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + K"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
        ];
      }
      {
        _args = [
          "${mainMod} + J"
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
        ];
      }

      # --- Window swapping ---
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

      # --- Workspace switching (Refactored to hl.dsp.focus) ---
      {_args = ["${mainMod} + 1" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 1 })")];}
      {_args = ["${mainMod} + 2" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 2 })")];}
      {_args = ["${mainMod} + 3" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 3 })")];}
      {_args = ["${mainMod} + 4" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 4 })")];}
      {_args = ["${mainMod} + 5" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 5 })")];}
      {_args = ["${mainMod} + 6" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 6 })")];}
      {_args = ["${mainMod} + 7" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 7 })")];}
      {_args = ["${mainMod} + 8" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 8 })")];}
      {_args = ["${mainMod} + 9" (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 9 })")];}

      # --- Move windows to workspaces (Refactored to hl.dsp.window.move) ---
      {_args = ["${mainMod} + SHIFT + 1" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1 })")];}
      {_args = ["${mainMod} + SHIFT + 2" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2 })")];}
      {_args = ["${mainMod} + SHIFT + 3" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3 })")];}
      {_args = ["${mainMod} + SHIFT + 4" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4 })")];}
      {_args = ["${mainMod} + SHIFT + 5" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5 })")];}
      {_args = ["${mainMod} + SHIFT + 6" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6 })")];}
      {_args = ["${mainMod} + SHIFT + 7" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7 })")];}
      {_args = ["${mainMod} + SHIFT + 8" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8 })")];}
      {_args = ["${mainMod} + SHIFT + 9" (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9 })")];}

      # --- Scratchpad ---
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

      # --- Mouse binds ---
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

      # --- Volume / brightness ---
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

      # --- Audio playback ---
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
  };
}
