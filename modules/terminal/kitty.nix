_: {
  flake.modules.homeManager.kitty = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) ansi font colors16;
      in {
        terminal = {
          argv = ["${pkgs.kitty}/bin/kitty" "--single-instance"];
          fallbackArgv = ["${pkgs.kitty}/bin/kitty"];
          appIdArgv = id: ["--class" id];
          compactArgv = config.terminal.transientArgv ++ ["-o" "font_size=${toString config.terminal.compactSize}"];
          desktopFile = "kitty.desktop";
          binary = "kitty";
        };

        programs.kitty = {
          enable = true;

          # load-bearing: docs/decisions/terminal.md#kitty-font-option
          font = {
            name = font.name;
            size = font.size;
            package = null;
          };

          settings =
            {
              window_padding_width = 8;
              confirm_os_window_close = 0;
              remember_window_size = false;

              cursor_shape = "block";
              cursor_blink_interval = 0;
              # load-bearing: docs/decisions/terminal.md#kitty-cursor-trail
              cursor_trail = 3;
              cursor_trail_start_threshold = 2;

              enabled_layouts = "splits,stack";
              inactive_text_alpha = 0.8;

              mouse_hide_wait = "-1.0";
              focus_follows_mouse = false;
              copy_on_select = "yes";

              scrollback_lines = 10000;
              shell_integration = "no-cursor";

              # load-bearing: docs/decisions/terminal.md#terminal-ansi
              background = colors16.base00;
              foreground = colors16.base05;
              selection_background = colors16.base02;
              selection_foreground = colors16.base06;
              color16 = colors16.base09;
              color17 = colors16.base0F;
            }
            // lib.optionalAttrs (!font.ligatures) {disable_ligatures = "always";}
            // lib.listToAttrs (lib.imap0 (i: hex: lib.nameValuePair "color${toString i}" hex) ansi);

          keybindings = {
            "ctrl+shift+left" = "launch --location=vsplit --cwd=current";
            "ctrl+shift+right" = "launch --location=vsplit --cwd=current";
            "ctrl+shift+up" = "launch --location=hsplit --cwd=current";
            "ctrl+shift+down" = "launch --location=hsplit --cwd=current";

            "ctrl+left" = "neighboring_window left";
            "ctrl+down" = "neighboring_window down";
            "ctrl+up" = "neighboring_window up";
            "ctrl+right" = "neighboring_window right";

            "ctrl+1" = "goto_tab 1";
            "ctrl+2" = "goto_tab 2";
            "ctrl+3" = "goto_tab 3";
            "ctrl+4" = "goto_tab 4";
            "ctrl+5" = "goto_tab 5";
            "ctrl+6" = "goto_tab 6";
            "ctrl+7" = "goto_tab 7";
            "ctrl+8" = "goto_tab 8";
            "ctrl+9" = "goto_tab 9";
            "ctrl+0" = "goto_tab 10";

            "ctrl+shift+t" = "new_tab_with_cwd";
          };
        };
      }
    )
  ];
}
