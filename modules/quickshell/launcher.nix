_: {
  flake.modules.homeManager.quickshell = [
    (
      {
        pkgs,
        lib,
        ...
      }: let
        qs = lib.getExe pkgs.quickshell;
        ipc = target: "${qs} -c default ipc call ${target} toggle";
      in {
        launcher.argv = [qs "-c" "default" "ipc" "call" "launcher" "toggle"];
        clipboard.history = ipc "clipboard";

        # load-bearing: docs/decisions/quickshell.md#quickshell-layer-namespaces
        quickshell.overlayNamespaces = ["quickshell-launcher" "quickshell-clipboard"];

        services.cliphist = {
          enable = true;
          systemdTargets = ["wayland-session@hyprland.desktop.target"];
        };
      }
    )
  ];
}
