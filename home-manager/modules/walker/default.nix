{inputs, ...}: {
  imports = [inputs.walker.homeManagerModules.default];
  programs.walker = {
    enable = true;
    runAsService = true;

    themes."custom".style = builtins.readFile ./style.css;
    config = {
      # === General ===
      theme = "custom";
      force_keyboard_focus = false;
      close_when_open = true;
      click_to_close = true;
      selection_wrap = false;
      global_argument_delimiter = "#";
      exact_search_prefix = "'";
      disable_mouse = false;
      debug = false;

      # === Shell anchors ===
      shell = {
        anchor_top = true;
        anchor_bottom = true;
        anchor_left = true;
        anchor_right = true;
      };

      # === Placeholders ===
      placeholders = {
        default = {
          input = " Search";
          list = "No Results";
        };
      };

      # === Keybinds ===
      keybinds = {
        close = ["Escape"];
        next = ["alt j"];
        previous = ["alt k"];
        toggle_exact = ["ctrl e"];
        resume_last_query = ["ctrl r"];
        quick_activate = [];
      };

      # === Providers ===
      providers = {
        default = [
          "desktopapplications"
          "calc"
          "runner"
          "menus"
          "websearch"
        ];
        empty = ["desktopapplications"];
        max_results = 50;
      };
    };
  };
}
