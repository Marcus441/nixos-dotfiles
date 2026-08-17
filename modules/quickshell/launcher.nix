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

        services.cliphist = {
          enable = true;
          systemdTargets = ["wayland-session@hyprland.desktop.target"];
        };
      }
    )
  ];
}
