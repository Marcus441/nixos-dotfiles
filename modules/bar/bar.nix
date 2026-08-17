_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.bar.toggle = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that shows or hides the bar. Empty when no aspect provides an external one; a compositor with a built-in bar toggles it itself.";
        };
      }
    )
  ];
}
