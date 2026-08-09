_: {
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
}
