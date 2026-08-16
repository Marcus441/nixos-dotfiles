_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.powerMenu.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that opens the power menu. Empty when no aspect provides one.";
        };
      }
    )
  ];
}
