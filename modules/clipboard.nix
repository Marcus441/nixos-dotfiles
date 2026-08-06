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

  flake.modules.homeManager.hyprland = [
    {clipboard.history = "walker -m clipboard";}
  ];

  flake.modules.homeManager.dwl = [
    (
      {
        config,
        pkgs,
        lib,
        ...
      }: let
        cliphist = "${pkgs.cliphist}/bin/cliphist";
        wmenu = "${pkgs.wmenu}/bin/wmenu";
        wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";
      in {
        clipboard.history = "${cliphist} list | ${wmenu} ${lib.escapeShellArgs config.wmenu.flags} | ${cliphist} decode | ${wlCopy}";
      }
    )
  ];
}
