_: {
  # load-bearing: docs/decisions/terminal.md#terminal-daemons
  flake.modules.nixos.foot = [
    {dwl.autostart = ["foot --server"];}
  ];

  flake.modules.homeManager.foot = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) ansi font colors16;
        fontAt = size:
          "${font.name}:size=${toString size}"
          + lib.optionalString (!font.ligatures) ":fontfeatures=-calt,-liga,-clig,-dlig";
        fontStr = fontAt font.size;

        strip = c: lib.removePrefix "#" c;
      in {
        terminal = {
          argv = ["${pkgs.foot}/bin/footclient"];
          fallbackArgv = ["${pkgs.foot}/bin/foot"];
          appIdArgv = id: ["--app-id" id];
          compactArgv = config.terminal.transientArgv ++ ["--override" "main.font=${fontAt config.terminal.compactSize}"];
          desktopFile = "footclient.desktop";
          binary = "footclient";
        };

        programs.foot = {
          enable = true;
          # load-bearing: docs/decisions/terminal.md#terminal-daemons
          server.enable = true;
          settings = {
            main = {
              font = fontStr;
              pad = "8x8";
              initial-color-theme = "dark";
            };
            scrollback.lines = 10000;
            mouse.hide-when-typing = "yes";
            # load-bearing: docs/decisions/terminal.md#terminal-alt-scroll
            mouse.alternate-scroll-mode = "no";

            # load-bearing: docs/decisions/terminal.md#terminal-clipboard-keys
            key-bindings.clipboard-copy = "Control+Shift+c XF86Copy XF86Cut";

            # load-bearing: docs/decisions/terminal.md#terminal-ansi
            colors-dark =
              {
                foreground = strip colors16.base05;
                background = strip colors16.base00;

                cursor = "${strip colors16.base00} ${strip colors16.base05}";

                selection-foreground = strip colors16.base06;
                selection-background = strip colors16.base02;

                "16" = strip colors16.base09;
                "17" = strip colors16.base0F;
              }
              // lib.listToAttrs (lib.imap0 (
                  i: hex:
                    lib.nameValuePair
                    "${
                      if i < 8
                      then "regular"
                      else "bright"
                    }${toString (lib.mod i 8)}"
                    (strip hex)
                )
                ansi);
          };
        };
      }
    )
  ];
}
