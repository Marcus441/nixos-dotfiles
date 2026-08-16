_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.networkManager.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening a network-management UI, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        rgb = slot: "Color::Rgb(${lib.replaceStrings [";"] [", "] config.desktop.colorsRgb.${slot}})";

        # load-bearing: docs/decisions/tui.md#impala-darkgray
        impala = pkgs.impala.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              selected=$(grep -rl 'bg(Color::DarkGray).fg(Color::White)' src)
              substituteInPlace $selected \
                --replace-fail 'bg(Color::DarkGray).fg(Color::White)' 'bg(${rgb "base02"}).fg(Color::White)'

              surfaces=$(grep -rl 'bg(Color::DarkGray)' src)
              substituteInPlace $surfaces \
                --replace-fail 'bg(Color::DarkGray)' 'bg(${rgb "base01"})'
            '';
        });
      in {
        # load-bearing: docs/decisions/tui.md#impala-argv
        networkManager.command = lib.escapeShellArgs (
          config.terminal.compactArgv ++ config.terminal.exec ++ ["${impala}/bin/impala"]
        );

        home.packages = [impala];
      }
    )
  ];
}
