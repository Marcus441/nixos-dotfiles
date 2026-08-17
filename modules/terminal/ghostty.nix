_: {
  # load-bearing: docs/decisions/terminal.md#terminal-daemons
  flake.modules.nixos.ghostty = [
    {dwl.autostart = ["ghostty --gtk-single-instance=true --initial-window=false"];}
  ];

  flake.modules.homeManager.ghostty = [
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
          argv = ["${pkgs.ghostty}/bin/ghostty"];
          # load-bearing: docs/decisions/terminal.md#terminal-daemons
          fallbackArgv = ["${pkgs.ghostty}/bin/ghostty" "--gtk-single-instance=false"];
          # load-bearing: docs/decisions/terminal.md#terminal-appid
          appIdArgv = id: ["--class=${id}"];
          exec = ["-e"];
          compactArgv = config.terminal.transientArgv ++ ["--font-size=${toString config.terminal.compactSize}"];
          desktopFile = "com.mitchellh.ghostty.desktop";
          binary = "ghostty";
        };

        # load-bearing: docs/decisions/terminal.md#ghostty-enablement
        xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source = "${pkgs.ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";

        programs.ghostty = {
          enable = true;
          systemd.enable = true;
          settings = {
            font-family = font.name;
            font-size = font.terminalSize;
            font-feature = lib.optionals (!font.ligatures) ["-calt" "-liga" "-clig" "-dlig"];
            # load-bearing: docs/decisions/terminal.md#terminal-stroke-weight
            alpha-blending = "linear";
            adjust-underline-thickness = "50%";

            window-padding-x = 8;
            window-padding-y = 8;
            window-inherit-working-directory = true;
            window-inherit-font-size = true;
            working-directory = "home";
            # load-bearing: docs/decisions/terminal.md#ghostty-resident
            quit-after-last-window-closed = false;
            # load-bearing: docs/decisions/terminal.md#ghostty-single-instance
            gtk-single-instance = true;
            gtk-toolbar-style = "flat";
            resize-overlay = "never";

            cursor-style = "block";
            cursor-style-blink = false;
            # load-bearing: docs/decisions/terminal.md#ghostty-shader
            custom-shader = "${./cursor_smear.glsl}";

            unfocused-split-opacity = 0.8;
            split-inherit-working-directory = true;
            tab-inherit-working-directory = true;

            mouse-hide-while-typing = true;
            mouse-scroll-multiplier = 0.95;
            focus-follows-mouse = false;
            copy-on-select = true;

            shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo,title";
            async-backend = "epoll";

            confirm-close-surface = false;
            app-notifications = "no-clipboard-copy";

            # load-bearing: docs/decisions/terminal.md#terminal-ansi
            background = colors16.base00;
            foreground = colors16.base05;
            selection-background = colors16.base02;
            selection-foreground = colors16.base06;
            cursor-color = colors16.base05;
            palette =
              lib.imap0 (i: hex: "${toString i}=${hex}") ansi
              ++ [
                "16=${colors16.base09}"
                "17=${colors16.base0F}"
              ];

            # load-bearing: docs/decisions/terminal.md#ghostty-split-arrows
            keybind = [
              "ctrl+shift+s=new_split:down"
              "ctrl+shift+enter=new_split:right"

              "ctrl+left=goto_split:left"
              "ctrl+down=goto_split:down"
              "ctrl+up=goto_split:up"
              "ctrl+right=goto_split:right"

              "ctrl+1=goto_tab:1"
              "ctrl+2=goto_tab:2"
              "ctrl+3=goto_tab:3"
              "ctrl+4=goto_tab:4"
              "ctrl+5=goto_tab:5"
              "ctrl+6=goto_tab:6"
              "ctrl+7=goto_tab:7"
              "ctrl+8=goto_tab:8"
              "ctrl+9=goto_tab:9"
              "ctrl+0=goto_tab:10"

              "alt+l=clear_screen"

              "ctrl+shift+t=new_tab"
              "ctrl+shift+o=toggle_tab_overview"

              "cut=copy_to_clipboard:mixed"
            ];
          };
        };
      }
    )
  ];
}
