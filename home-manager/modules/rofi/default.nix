{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;

    extraConfig = {
      show-icons = true; # Often needed for icons to show up
      drun-display-format = "{name}"; # Simplifies the display name for drun mode
      run-display-format = "{name}"; # Simplifies the display name for run mode
      window-display-format = "{name}"; # Simplifies the display name for window mode
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        border = 0;
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      window = {
        transparency = "real";
      };

      mainbox = {
        children = map mkLiteral ["inputbar" "listview"];
      };

      inputbar = {
        children = map mkLiteral ["prompt" "entry"];
      };

      entry = {
        padding = mkLiteral "12px 3px";
      };

      prompt = {
        padding = mkLiteral "12px";
      };

      listview = {
        lines = 8;
      };

      element = {
        children = map mkLiteral ["element-icon" "element-text"];
      };

      element-icon = {
        padding = mkLiteral "10px 10px";
      };

      element-text = {
        padding = mkLiteral "10px 0";
      };
    };
  };
}
