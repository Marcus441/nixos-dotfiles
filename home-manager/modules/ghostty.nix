{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      # Window padding
      window-padding-x = 15;
      window-padding-y = 15;
      font-size = 13.5;

      confirm-close-surface = false;

      # Font
      font-feature = "builtin_box_drawing";

      # Cursor
      cursor-style = "block";
      copy-on-select = true;
      keybind = [
        # Create splits
        "ctrl+alt+h=new_split:left"
        "ctrl+alt+j=new_split:down"
        "ctrl+alt+k=new_split:up"
        "ctrl+alt+l=new_split:right"

        # Split navigation like Vim
        "unconsumed:ctrl+alt+h=goto_split:left"
        "unconsumed:ctrl+alt+j=goto_split:down"
        "unconsumed:ctrl+alt+k=goto_split:up"
        "unconsumed:ctrl+alt+l=goto_split:right"

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
