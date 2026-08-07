{inputs, ...}: {
  # The launcher belongs to the session that binds a key to it, not to "the
  # extra applications". Both roles it fills are named here rather than in
  # hyprland-binds.nix, so swapping launcher is one file.
  flake.modules.nixos.hyprland = [
    {
      nix.settings = {
        extra-substituters = [
          "https://walker.cachix.org"
          "https://walker-git.cachix.org"
        ];
        extra-trusted-public-keys = [
          "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
          "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
        ];
      };
    }
  ];

  flake.modules.homeManager.hyprland = [
    inputs.walker.homeManagerModules.default
    (
      {
        config,
        lib,
        ...
      }: {
        launcher.argv = ["walker"];
        clipboard.history = "walker -m clipboard";

        programs.walker = {
          enable = true;
          runAsService = true;

          config = {
            theme = "custom";
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

          themes."custom" = {
            style = import ./_walker/style.nix {colors = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors;};
            layouts = {
              "layout" = import ./_walker/layout.nix;
              "item_calc" = import ./_walker/item_calc.nix;
              "item_menus-wallpapers" = import ./_walker/item_menus_wallpapers.nix;
            };
          };
        };
      }
    )
  ];
}
