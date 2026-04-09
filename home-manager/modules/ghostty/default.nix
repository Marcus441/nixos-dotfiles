{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Kanagawa Dragon";
      # Window padding
      window-padding-x = 10;
      window-padding-y = 10;
      font-size = 14;

      resize-overlay = "never";
      unfocused-split-opacity = 0.8;

      mouse-hide-while-typing = true;
      focus-follows-mouse = false;

      confirm-close-surface = false;
      custom-shader = "/home/marcus/flake/home-manager/modules/ghostty/cursor_smear.glsl";
      scrollback-limit = 10000;

      # Font
      font-feature = "builtin_box_drawing";

      app-notifications = "no-clipboard-copy";

      # Cursor
      cursor-style = "block";
      copy-on-select = true;

      working-directory = "home";
      window-inherit-working-directory = true;
      tab-inherit-working-directory = true;
      split-inherit-working-directory = true;
      window-inherit-font-size = true;

      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "10m";

      keybind = [
        # Create splits
        "alt+left=new_split:left"
        "alt+down=new_split:down"
        "alt+up=new_split:up"
        "alt+right=new_split:right"

        # Split navigation
        "ctrl+left=goto_split:left"
        "ctrl+down=goto_split:down"
        "ctrl+up=goto_split:up"
        "ctrl+right=goto_split:right"

        "ctrl+shift+left=resize_split:left,10"
        "ctrl+shift+down=resize_split:down,10"
        "ctrl+shift+up=resize_split:up,10"
        "ctrl+shift+right=resize_split:right,10"

        # Tab Navigation
        "ctrl+1=goto_tab:1"
        "ctrl+2=goto_tab:2"
        "ctrl+3=goto_tab:3"
        "ctrl+4=goto_tab:4"
        "ctrl+5=goto_tab:5"
        "ctrl+6=goto_tab:6"
        "ctrl+7=goto_tab:7"
        "ctrl+8=goto_tab:8"
        "ctrl+9=goto_tab:9"
        "ctrl+0=goto_tab:10"

        # Standard Tab controls
        "ctrl+t=new_tab"
        "ctrl+w=close_tab:this"
        "ctrl+shift+o=toggle_tab_overview"
      ];
    };
  };
}
