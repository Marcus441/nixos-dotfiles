_: {
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
}
