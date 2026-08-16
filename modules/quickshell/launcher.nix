_: {
  flake.modules.homeManager.quickshell = [
    (
      {
        pkgs,
        lib,
        ...
      }: let
        qs = lib.getExe pkgs.quickshell;
      in {
        launcher.argv = [qs "-c" "default" "ipc" "call" "launcher" "toggle"];
        clipboard.history = "${qs} -c default ipc call clipboard toggle";

        services.cliphist = {
          enable = true;
          systemdTargets = ["wayland-session@hyprland.desktop.target"];
        };
      }
    )
  ];
}
