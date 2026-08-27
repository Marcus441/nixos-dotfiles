_: {
  flake.modules.homeManager.hyprland = [
    (
      {config, ...}: {
        # load-bearing: docs/decisions/terminal.md#xdg-terminals-list
        xdg.configFile."xdg-terminals.list".text = "${config.terminal.desktopFile}\n";
      }
    )
  ];
}
