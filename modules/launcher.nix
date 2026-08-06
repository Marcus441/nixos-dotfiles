{...}: {
  # Portable intent, per-session implementation (§3). `argv` rather than a bare
  # string because dwl's binds are a C argv array while Hyprland's are shell
  # strings; `command` is the shell rendering of the same value.
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        ...
      }: {
        options.launcher = {
          argv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Program and arguments that open the application launcher.";
          };

          command = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = lib.escapeShellArgs config.launcher.argv;
            description = "`argv` as a shell command.";
          };
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    {launcher.argv = ["walker"];}
  ];

  flake.modules.homeManager.dwl = [
    (
      {
        config,
        pkgs,
        ...
      }: {
        launcher.argv = ["${pkgs.wmenu}/bin/wmenu-run"] ++ config.wmenu.flags;
      }
    )
  ];
}
