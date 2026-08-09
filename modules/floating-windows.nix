_: {
  # `hyprland`, not `core`: floating is a decision a session makes, and dwl
  # makes the opposite one. `windowTags` lives in `core` because its values are
  # inert data a session is free to ignore -- an app-id is not, it changes the
  # argv a spawn point executes, so a dwl host would be running commands that
  # assert a window behaviour its compositor rejects.
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: {
        # Options rather than bare strings: the spawn side has to name the
        # app-id it launches under (see foot.nix's `terminal.transientArgv`), and
        # a literal repeated there and in the rule below is two places to change
        # one convention.
        options.floatingWindow = {
          term = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "floating-term";
            description = "app-id a terminal sets to open as a floating window.";
          };

          app = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            default = "floating-app";
            description = "app-id a GUI utility sets to open as a floating window.";
          };
        };

        # Two canonical app-ids carry the floating-window tag; the shared
        # behaviours (float, center, size) live once in ./hyprland-rules.nix, so
        # neither app-id needs a rule of its own. An app that can name itself
        # opts in at spawn time -- `footclient --app-id floating-term` floats,
        # plain `footclient` keeps app-id `footclient` and tiles.
        #
        # The limit of the convention: app-id is set by the client, and Wayland
        # has no outside override for it the way X11 had `--class`. Of the
        # windows this config floats, only foot takes `--app-id`. pavucontrol,
        # blueman-manager and thunar have no such flag (checked), and
        # xdg-desktop-portal-gtk is D-Bus activated -- there is no spawn site to
        # pass a flag to. Those four keep matching their real class in the file
        # that installs them, which floats *every* instance of each. Accepted:
        # the alternatives are a title match or a rename wrapper, both of which
        # break silently the next time the app changes a string.
        config.windowTags.floating-window = [
          "^(${config.floatingWindow.term})$"
          "^(${config.floatingWindow.app})$"
        ];
      }
    )
  ];
}
