{
  programs.ghostty = {
    enable = true;
    settings = {
      # Window padding
      window-padding-x = 15;
      window-padding-y = 15;

      # Font
      font-feature = "builtin_box_drawing"; # Ghostty enables box drawing by default

      # Cursor
      cursor-style = "block";

      # Env
      term = "xterm-256color";
    };
  };
}
