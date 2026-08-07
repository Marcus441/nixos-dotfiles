_: {
  # Two intents render through wmenu: the launcher (wmenu-run) and the clipboard
  # picker (wmenu). Its theming is therefore neither intent's business, so it is
  # an option both of them read.
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
      in {
        options.wmenu.flags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Flags themed to match dwl's bar schemes; vertical, 10 lines.";
        };

        # Both roles hold the store path, so wmenu is only on PATH for the
        # human. dwl compiles the argv straight into its C keybind array.
        config.home.packages = [pkgs.wmenu];

        config.launcher.argv = ["${pkgs.wmenu}/bin/wmenu-run"] ++ config.wmenu.flags;

        config.clipboard.history = "${cliphist} list | ${pkgs.wmenu}/bin/wmenu ${lib.escapeShellArgs config.wmenu.flags} | ${cliphist} decode | ${wlCopy}";

        config.wmenu.flags = [
          "-f"
          "${font.name} 10"
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
      }
    )
  ];
}
