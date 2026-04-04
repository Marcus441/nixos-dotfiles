{
  config,
  inputs,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];

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
          input = " Search...";
          list = "No Results";
        };
      };

      providers = {
        max_results = 256;
        default = [
          "desktopapplications"
          "websearch"
          "way-wall"
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
      style = import ./style.nix {inherit config;};
      layouts = {
        "layout" = import ./layout.nix {};
      };
    };
  };
}
