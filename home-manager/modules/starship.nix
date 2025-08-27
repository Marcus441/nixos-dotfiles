{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        # style = "bold #87AF87";
      };

      character = {
        success_symbol = "[➜]($style)"; # arrow forward(bold #929D5B)
        error_symbol = "[✘]($style)"; # error: red cross (bold #f2594b)
      };

      username = {
        show_always = true;
        format = "[$user]($style)@";
        # style_user = "bold #EA6962"; # red
      };

      directory = {
        read_only = " 🔒";
        truncation_symbol = "…/";
        # style = "#A5B163";
      };
    };
  };
}
