_: {
  # load-bearing: docs/decisions/terminal.md#terminal-daemons
  flake.modules.nixos.kitty = [
    {dwl.autostart = ["kitty --single-instance --start-as=hidden"];}
  ];

  flake.modules.homeManager.kitty = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) ansi colors font colors16;
      in {
        # load-bearing: docs/decisions/terminal.md#terminal-daemons
        systemd.user.services.kitty = {
          Unit = {
            Description = "kitty in headless single-instance mode, resident so that opening a window costs nothing";
            PartOf = ["graphical-session.target"];
            After = ["graphical-session.target"];
            ConditionEnvironment = "WAYLAND_DISPLAY";
          };

          Install.WantedBy = ["graphical-session.target"];

          Service = {
            ExecStart = "${pkgs.kitty}/bin/kitty --single-instance --start-as=hidden";
            Restart = "on-failure";
          };
        };

        terminal = {
          # load-bearing: docs/decisions/terminal.md#kitty-single-instance
          argv = ["${pkgs.kitty}/bin/kitty" "--single-instance"];
          fallbackArgv = ["${pkgs.kitty}/bin/kitty"];
          appIdArgv = id: ["--class" id];
          # load-bearing: docs/decisions/terminal.md#kitty-compact-group
          compactArgv =
            config.terminal.transientArgv
            ++ ["--instance-group=compact" "-o" "font_size=${toString config.terminal.compactSize}"];
          desktopFile = "kitty.desktop";
          binary = "kitty";
        };

        programs.kitty = {
          enable = true;

          # load-bearing: docs/decisions/terminal.md#kitty-font-option
          font = {
            inherit (font) name;
            size = font.terminalSize;
            package = null;
          };

          settings =
            {
              window_padding_width = 8;
              confirm_os_window_close = 0;
              remember_window_size = false;

              # load-bearing: docs/decisions/terminal.md#terminal-stroke-weight
              text_composition_strategy = "1.0 25";
              undercurl_style = "thick-dense";

              cursor_shape = "block";
              cursor_blink_interval = 0;
              # load-bearing: docs/decisions/terminal.md#kitty-cursor-trail
              cursor_trail = 3;
              cursor_trail_start_threshold = 2;

              # load-bearing: docs/decisions/terminal.md#kitty-splits-only
              enabled_layouts = "splits";
              # load-bearing: docs/decisions/terminal.md#kitty-split-navigation
              allow_remote_control = "socket-only";
              listen_on = "unix:@mykitty";
              # load-bearing: docs/decisions/terminal.md#kitty-inactive-alpha
              inactive_text_alpha = -0.8;

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
              cursor = colors16.base05;
              cursor_text_color = colors16.base00;
              color16 = colors16.base09;
              color17 = colors16.base0F;

              active_tab_background = colors.base10;
              active_tab_foreground = colors16.base06;
              inactive_tab_background = colors.base10;
              inactive_tab_foreground = colors16.base04;

              # load-bearing: docs/decisions/terminal.md#kitty-borders
              active_border_color = colors16.base0D;
              inactive_border_color = colors16.base03;
              bell_border_color = colors16.base08;
            }
            // lib.optionalAttrs (!font.ligatures) {disable_ligatures = "always";}
            // lib.listToAttrs (lib.imap0 (i: hex: lib.nameValuePair "color${toString i}" hex) ansi);

          keybindings = {
            "ctrl+shift+enter" = "launch --location=vsplit --cwd=current";
            "ctrl+shift+s" = "launch --location=hsplit --cwd=current";

            "ctrl+h" = "neighboring_window left";
            "ctrl+j" = "neighboring_window down";
            "ctrl+k" = "neighboring_window up";
            "ctrl+l" = "neighboring_window right";

            "alt+h" = "kitten relative_resize.py left 3 alt+h";
            "alt+j" = "kitten relative_resize.py down 3 alt+j";
            "alt+k" = "kitten relative_resize.py up 3 alt+k";
            "alt+l" = "kitten relative_resize.py right 3 alt+l";

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
            "ctrl+shift+o" = "select_tab";
            # load-bearing: docs/decisions/terminal.md#kitty-splits-only
            "ctrl+shift+l" = "clear_terminal to_cursor_scroll active";

            "XF86Copy" = "copy_to_clipboard";
            "XF86Cut" = "copy_or_noop";
            "XF86Paste" = "paste_from_clipboard";
          };

          # load-bearing: docs/decisions/terminal.md#kitty-split-navigation
          extraConfig = ''
            map --when-focus-on var:IS_NVIM ctrl+h
            map --when-focus-on var:IS_NVIM ctrl+j
            map --when-focus-on var:IS_NVIM ctrl+k
            map --when-focus-on var:IS_NVIM ctrl+l

            map --when-focus-on var:IS_NVIM alt+h
            map --when-focus-on var:IS_NVIM alt+j
            map --when-focus-on var:IS_NVIM alt+k
            map --when-focus-on var:IS_NVIM alt+l
          '';
        };

        # load-bearing: docs/decisions/terminal.md#kitty-split-navigation
        xdg.configFile = let
          kittens = "${pkgs.vimPlugins.smart-splits-nvim}/kitty";
        in {
          "kitty/neighboring_window.py".source = "${kittens}/neighboring_window.py";
          "kitty/relative_resize.py".source = "${kittens}/relative_resize.py";
          "kitty/split_window.py".source = "${kittens}/split_window.py";
        };
      }
    )
  ];
}
