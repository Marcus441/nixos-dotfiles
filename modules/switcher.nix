_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.switcher.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that opens the workspace and window switcher. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.quickshell = [
    (
      {
        pkgs,
        lib,
        ...
      }: {
        switcher.command = "${lib.getExe pkgs.quickshell} -c default ipc call switcher toggle";

        # load-bearing: docs/decisions/switcher.md#quickshell-switcher
        wayland.windowManager.hyprland.settings.layer_rule = [
          {
            name = "no-anim-quickshell-switcher";
            match = {namespace = "quickshell-switcher";};
            no_anim = true;
          }
        ];
      }
    )
  ];
}
