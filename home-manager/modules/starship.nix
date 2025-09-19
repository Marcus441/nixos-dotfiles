{config, ...}: let
  accent = "#${config.lib.stylix.colors.base0E}";
  red = "#${config.lib.stylix.colors.base08}";
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold ${accent})";
        error_symbol = "[✘](bold ${red})";
      };

      directory = {
        read_only = " 🔒";
      };
    };
  };
}
