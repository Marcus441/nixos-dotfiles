{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        style = "bold #80aa9e"; # blue
      };

      character = {
        success_symbol = "[ > ](bold #80aa9e)"; # blue
        error_symbol = "[ > ](bold #f2594b)";   # red
      };

      username = {
        show_always = true;
        format = "[$user]($style)@";
        style = "bold #80aa9e"; # blue
      };

      directory = {
        read_only = " 🔒";
        truncation_symbol = "…/";
      };
    };
  };
}

