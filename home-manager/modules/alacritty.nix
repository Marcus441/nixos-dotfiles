{ config, lib, ... }:


{
# Fetch the theme repo into your config
  home.file.".config/alacritty/themes".source = 
    builtins.fetchGit {
      url = "https://github.com/alacritty/alacritty-theme.git";
      rev = "0520b1f8f3eb25678444c0817a97636b6601ac85"; # You can pin a specific commit for stability
      allRefs = true;
    };


  programs.alacritty = {
    enable = true;
    settings = {

      general.import = [
        "${config.home.homeDirectory}/.config/alacritty/themes/themes/gruvbox_material_hard_dark.toml"
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

