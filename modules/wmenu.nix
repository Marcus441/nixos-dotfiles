_: {
  # wmenu is dwl's menu program, and two intents render through it: the launcher
  # (wmenu-run) and the clipboard picker (wmenu). Its theming is therefore
  # neither intent's business, so it is an option both of them read.
  flake.modules.homeManager.dwl = [
    (
      {
        config,
        lib,
        ...
      }: let
        inherit (config.desktop) colors font;
      in {
        options.wmenu.flags = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "Flags themed to match dwl's bar schemes; vertical, 10 lines.";
        };

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
