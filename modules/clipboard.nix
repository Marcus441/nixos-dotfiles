_: {
  # Compositor-agnostic: both sessions bind a clipboard-history key.
  flake.modules.homeManager.core = [
    (
      {
        pkgs,
        lib,
        ...
      }: {
        options.clipboard.history = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that opens the clipboard history picker.";
        };

        config.home.packages = with pkgs; [
          wl-clipboard
          cliphist
        ];
      }
    )
  ];

  # The picker renders through the same menu program as the launcher, so the
  # aspect that provides one provides the other -- walker.nix and wmenu.nix.
}
