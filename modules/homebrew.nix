_: {
  flake.modules.darwin.core = [
    {
      homebrew = {
        enable = true;
        # load-bearing: docs/decisions/darwin.md#homebrew-cleanup
        onActivation.cleanup = "none";
        global.brewfile = true;
      };

      # load-bearing: docs/decisions/darwin.md#homebrew-cleanup
      environment.variables.HOMEBREW_BUNDLE_CLEANUP_NO_MAS = "1";
    }
  ];
}
