_: {
  # The launcher belongs to the session that binds a key to it, not to "the
  # extra applications". Both roles it fills are named here rather than in
  # hyprland-binds.nix, so swapping launcher is one file.
  flake.modules.homeManager.hyprland = [
    {
      launcher.argv = ["walker"];
      clipboard.history = "walker -m clipboard";

      services.walker = {
        enable = true;
        systemd.enable = true;

        # `theme` is not set here: walker-style.nix owns the theme and the
        # module derives `settings.theme` from its name.
        settings = {
          force_keyboard_focus = true;
          selection_wrap = true;
          hide_action_hints = true;
          close_when_open = true;
          click_to_close = true;
          global_argument_delimiter = "#";
          exact_search_prefix = "'";

          placeholders = {
            "default" = {
              input = "Search...";
              list = "No Results";
            };
          };

          providers = {
            max_results = 256;
            ignore_preview = [
              "desktopapplications"
              "windows"
            ];
            default = [
              "desktopapplications"
              "windows"
            ];
            prefixes = [
              {
                prefix = "/";
                provider = "providerlist";
              }
              {
                prefix = ".";
                provider = "files";
              }
              {
                prefix = ":";
                provider = "symbols";
              }
              {
                prefix = "=";
                provider = "calc";
              }
              {
                prefix = "@";
                provider = "websearch";
              }
              {
                prefix = "$";
                provider = "clipboard";
              }
              {
                prefix = "+";
                provider = "menus:wallpapers";
              }
            ];
          };

          emergencies = [
            {
              text = "Restart Walker";
              command = "systemctl --user restart walker.service";
            }
          ];
        };
      };
    }
  ];
}
