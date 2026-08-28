_: {
  flake.modules.homeManager.quickshell = [
    (
      {
        lib,
        config,
        ...
      }: {
        options.quickshell.overlayNamespaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "Layershell namespaces of quickshell overlays that open from a keybind and must not animate in.";
        };

        config.wayland.windowManager.hyprland.settings.layer_rule =
          map (namespace: {
            name = "no-anim-${namespace}";
            match = {inherit namespace;};
            no_anim = true;
          })
          config.quickshell.overlayNamespaces;
      }
    )
  ];
}
