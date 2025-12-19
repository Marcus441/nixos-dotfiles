{
  programs.ghostty = {
    enable = true;
    themes = {
      kanagawa-dragon-nvim = {
        background = "#181616";
        cursor-color = "#c8c093";
        foreground = "#c5c9c5";
        palette = [
          "0=#0d0c0c"
          "1=#c4746e"
          "2=#8a9a7b"
          "3=#c4b28a"
          "4=#8ba4b0"
          "5=#a292a3"
          "6=#8ea4a2"
          "7=#c8c093"
          "8=#a6a69c"
          "9=#e46876"
          "10=#87a987"
          "11=#e6c384"
          "12=#7fb4ca"
          "13=#938aa9"
          "14=#7aa89f"
          "15=#c5c9c5"
        ];
        selection-background = "#2d4f67";
        selection-foreground = "#c8c093";
      };
    };
    settings = {
      # Window padding
      window-padding-x = 10;
      window-padding-y = 10;
      font-size = 13.5;

      confirm-close-surface = false;
      custom-shader = "/home/marcus/flake/home-manager/modules/ghostty/cursor_smear.glsl";

      theme = "kanagawa-dragon-nvim";
      # Font
      font-feature = "builtin_box_drawing";

      app-notifications = "no-clipboard-copy";

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
