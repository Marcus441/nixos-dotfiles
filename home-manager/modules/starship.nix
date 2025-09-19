{config, ...}: let
  red = "#${config.lib.stylix.colors.base08}";
  green = "#${config.lib.stylix.colors.base0B}";
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold ${green})";
        error_symbol = "[✘](bold ${red})";
      };

      directory = {
        read_only = " 🔒";
      };
    };
  };
}
