_: {
  flake.modules.darwin.core = [
    {
      homebrew = {
        enable = true;
        # load-bearing: docs/decisions/darwin.md#homebrew-cleanup
        onActivation.cleanup = "zap";
      };
    }
  ];
}
