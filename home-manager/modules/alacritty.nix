{ pkgs, lib, ... }:


{
  programs.alacritty = {
    enable = true;
    settings = {

      general.import = [
        "${pkgs.alacritty-theme}/themes/gruvbox_material_hard_dark.toml"
      ];

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

