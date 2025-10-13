{lib, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      label = {
        text = "$TIME";
        font_size = 96;
        position = "0, 600";
        halign = "center";
        walign = "center";
        shadow_passes = 1;
      };

      background = lib.mkDefault [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = lib.mkDefault [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          outline_thickness = 5;
          shadow_passes = 1;
        }
      ];
    };
  };
}
