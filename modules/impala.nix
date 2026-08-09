_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        # Same shape as `fileManager.command` (§3): the aspect that installs the
        # tool names it, and a bar renders whatever it finds -- or omits the
        # click entirely rather than binding one that opens nothing.
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
        # impala drives iwd over D-Bus. net.nix runs NetworkManager with
        # `wifi.backend = "iwd"`, so both talk to the same daemon -- impala sees
        # real networks, but a connection it makes is one NetworkManager did not
        # author, so NM's own state can disagree until it resyncs.
        #
        # A TUI has to carry its own terminal. Composed at argv level and
        # rendered once, because `terminal.floatingCommand` is already escaped
        # and appending to it would escape twice.
        networkManager.command = lib.escapeShellArgs (
          config.terminal.floatingArgv ++ ["${pkgs.impala}/bin/impala"]
        );

        home.packages = [pkgs.impala];
      }
    )
  ];
}
