{ lib, ... }:


{
  programs.alacritty = {
    enable = true;
    settings = {

      window = {
        padding.x = 15;
        padding.y = 15;
      };

      font = {
        builtin_box_drawing = true;
        normal = {
          style = lib.mkForce "Bold";
        };
      };
      terminal.shell = {
        program = "zsh";
      };

      cursor.style = {
        shape = "Block";
        blinking = "Always";
      };

      selection.save_to_clipboard = true;

      env = {
        TERM = "xterm-256color";
      };
    };
  };
}

