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
      }: {
        # load-bearing: docs/decisions/terminal.md#impala-argv
        networkManager.command = lib.escapeShellArgs (
          config.terminal.transientArgv ++ ["${pkgs.impala}/bin/impala"]
        );

        home.packages = [pkgs.impala];
      }
    )
  ];
}
