{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window padding
      window-padding-x = 10;
      window-padding-y = 10;
      font-size = 13.5;

      confirm-close-surface = false;
      # custom-shader = "/home/marcus/flake/home-manager/modules/ghostty/cursor_smear.glsl";

      # Font
      font-feature = "builtin_box_drawing";

      app-notifications = "no-clipboard-copy";
      background-opacity = "1";
      # Cursor
      cursor-style = "block";
      copy-on-select = true;
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

        "alt+1=unbind"
        "alt+2=unbind"
        "alt+3=unbind"
        "alt+4=unbind"
        "alt+5=unbind"
        "alt+6=unbind"
        "alt+7=unbind"
        "alt+8=unbind"
        "alt+9=unbind"
        "alt+0=unbind"
      ];
    };
  };
}
