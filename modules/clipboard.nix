_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.clipboard.history = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that opens the clipboard history picker.";
        };
      }
    )
  ];

  flake.modules.homeManager.wayland = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          wl-clipboard
          cliphist
        ];
      }
    )
  ];
}
