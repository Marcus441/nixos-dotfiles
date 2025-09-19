{config, ...}: let
  accent = "#${config.lib.stylix.colors.base0E}";
  red = "#${config.lib.stylix.colors.base08}";
  green = "#${config.lib.stylix.colors.base0B}";
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        style = "bold ${green}";
      };

      character = {
        success_symbol = "[➜](bold ${accent})";
        error_symbol = "[✘](bold ${red})";
      };

      username = {
        show_always = true;
        format = "[$user]($style)@";
        style_user = "bold ${accent}";
      };

      directory = {
        read_only = " 🔒";
        truncation_symbol = "…/";
        style = "${green}";
      };
    };
  };
}
