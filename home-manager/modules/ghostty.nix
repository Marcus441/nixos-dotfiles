{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window padding
      window-padding-x = 15;
      window-padding-y = 15;

      # Font
      font-feature = "builtin_box_drawing";

      # Cursor
      cursor-style = "block";
      copy-on-select = true;

      # Env
      term = "xterm-256color";
      keybind = [
        # Create splits
        "alt+h=new_split:left"
        "alt+j=new_split:down"
        "alt+k=new_split:up"
        "alt+l=new_split:right"

        # Split navigation like Vim
        "unconsumed:ctrl+h=goto_split:left"
        "unconsumed:ctrl+j=goto_split:down"
        "unconsumed:ctrl+k=goto_split:up"
        "unconsumed:ctrl+l=goto_split:right"

        # Resize splits
        "ctrl+shift+h=resize_split:left,10"
        "ctrl+shift+l=resize_split:right,10"
        "ctrl+shift+j=resize_split:down,10"
        "ctrl+shift+k=resize_split:up,10"

        # Clear screen
        "ctrl+s=clear_screen"

        # Tab management
        "alt+enter=new_tab"
        "alt+n=next_tab"
        "alt+p=previous_tab"

        # Copy/Paste
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}
