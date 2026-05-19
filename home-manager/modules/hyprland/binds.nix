{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    # Define the mod key as a Lua variable
    mainMod = {
      _var = "SUPER";
    };

    bind = [
      # --- General ---
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + C\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- hyprpicker -an\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + S\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- grimblast --notify --freeze copysave screen\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + Z\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm stop\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + B\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"systemctl --user is-active --quiet waybar && systemctl --user stop waybar || systemctl --user start waybar\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + C\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"uwsm app -- ocr-copy\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + D\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker\")")
        ];
      }
      {
        # Assumes fileManager is defined as a Lua variable elsewhere via _var
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + E\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(fileManager)")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + F\"")
          (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + Q\"")
          (lib.generators.mkLuaInline "hl.dsp.window.close()")
        ];
      }
      {
        # Assumes terminal is defined as a Lua variable elsewhere via _var
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + Return\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
        ];
      }
      # layoutmsg / togglesplit
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + S\"")
          (lib.generators.mkLuaInline "hl.dsp.layout(\"togglesplit\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + Tab\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m windows\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + V\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m clipboard\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + W\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"walker -m menus:wallpapers\")")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + Z\"")
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
          (lib.generators.mkLuaInline "mainMod .. \" + H\"")
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + L\"")
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + K\"")
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + J\"")
          (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
        ];
      }

      # --- Window swapping ---
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + H\"")
          (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"l\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + L\"")
          (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"r\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + K\"")
          (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"u\" })")
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + J\"")
          (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"d\" })")
        ];
      }

      # --- Workspace switching ---
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 1\"") (lib.generators.mkLuaInline "hl.workspace(1)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 2\"") (lib.generators.mkLuaInline "hl.workspace(2)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 3\"") (lib.generators.mkLuaInline "hl.workspace(3)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 4\"") (lib.generators.mkLuaInline "hl.workspace(4)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 5\"") (lib.generators.mkLuaInline "hl.workspace(5)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 6\"") (lib.generators.mkLuaInline "hl.workspace(6)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 7\"") (lib.generators.mkLuaInline "hl.workspace(7)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 8\"") (lib.generators.mkLuaInline "hl.workspace(8)")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + 9\"") (lib.generators.mkLuaInline "hl.workspace(9)")];}

      # --- Move windows to workspaces (silent) ---
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 1\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 1, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 2\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 2, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 3\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 3, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 4\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 4, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 5\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 5, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 6\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 6, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 7\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 7, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 8\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 8, follow = false })")];}
      {_args = [(lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 9\"") (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = 9, follow = false })")];}

      # --- Scratchpad ---
      # Scratchpad toggle
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + 0\"")
          (lib.generators.mkLuaInline "hl.dsp.workspace.toggle_special(\"magic\")")
        ];
      }

      # Scratchpad send (silent = follow = false)
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + SHIFT + 0\"")
          (lib.generators.mkLuaInline "hl.dsp.window.move({ workspace = \"special:magic\" })")
        ];
      }

      # --- Mouse binds (was bindm) ---
      # drag() = movewindow, resize() = resizewindow — confirmed in docs
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + mouse:272\"")
          (lib.generators.mkLuaInline "hl.dsp.window.drag()")
          {mouse = true;}
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + mouse:273\"")
          (lib.generators.mkLuaInline "hl.dsp.window.resize()")
          {mouse = true;}
        ];
      }

      # --- Volume / brightness (was bindel: repeating + locked) ---
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
          (lib.generators.mkLuaInline "mainMod .. \" + bracketright\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%+\")")
          {
            repeating = true;
            locked = true;
          }
        ];
      }
      {
        _args = [
          (lib.generators.mkLuaInline "mainMod .. \" + bracketleft\"")
          (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"brightnessctl s 10%-\")")
          {
            repeating = true;
            locked = true;
          }
        ];
      }

      # --- Audio playback (was bindl: locked only) ---
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
