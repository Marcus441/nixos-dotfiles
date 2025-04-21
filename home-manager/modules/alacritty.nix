{ lib, ... }: {
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
    };
  };
}
