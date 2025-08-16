{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;

    font = "JetBrainsMono Nerd Font Medium 10";

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

        bg = mkLiteral "#282828";
        bg-alt = mkLiteral "#232323";
        fg = mkLiteral "#DDC7A1";
        fg-alt = mkLiteral "#D4BE98";

        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg";
      };

      window = {
        transparency = "real";
      };

      mainbox = {
        children = map mkLiteral ["inputbar" "listview"];
      };

      inputbar = {
        background-color = mkLiteral "@bg-alt";
        children = map mkLiteral ["prompt" "entry"];
      };

      entry = {
        background-color = mkLiteral "inherit";
        padding = mkLiteral "12px 3px";
      };

      prompt = {
        background-color = mkLiteral "inherit";
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
        text-color = mkLiteral "@fg-alt";
      };

      "element-text.selected" = {
        text-color = mkLiteral "@fg";
      };
    };
  };
}
