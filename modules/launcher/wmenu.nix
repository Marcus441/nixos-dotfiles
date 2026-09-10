_: {
  flake.modules.homeManager.dwl = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) colors font;

        cliphist = "${pkgs.cliphist}/bin/cliphist";
        wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";

        wmenu = "${pkgs.wmenu}/bin/wmenu";
        flags = lib.escapeShellArgs [
          "-f"
          "${font.name} 12"
          "-l"
          "10"
          "-N"
          colors.base00
          "-n"
          colors.base05
          "-M"
          colors.base02
          "-m"
          colors.base05
          "-S"
          colors.base02
          "-s"
          colors.base05
        ];
      in {
        options.wmenu.cliphist-command = lib.mkOption {
          type = lib.types.str;
          description = "Command to spawn the clipboard history in wmenu";
        };
        options.wmenu.launcher-command = lib.mkOption {
          type = lib.types.str;
          description = "Command to spawn the .desktop app launcher in wmenu";
        };

        config = {
          home.packages = [pkgs.wmenu];

          wmenu.cliphist-command = "${cliphist} list | ${wmenu} ${flags} | ${cliphist} decode | ${wlCopy} ";
          wmenu.launcher-command = "${pkgs.wmenu}/bin/wmenu-run ${flags} ";
        };
      }
    )
  ];
}
