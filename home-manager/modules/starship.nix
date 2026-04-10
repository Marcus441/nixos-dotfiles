{
  programs.starship = {
    enable = true;
    enableTransience = true;

    settings = {
      add_newline = false;

      format = "$character$directory $git_branch$git_status ";

      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[➜](bold red) ";
        vimcmd_symbol = "[➜](bold blue) ";
        vimcmd_visual_symbol = "[➜](bold yellow) ";
        vimcmd_replace_symbol = "[➜](bold purple) ";
        vimcmd_replace_one_symbol = "[➜](bold purple) ";
      };

      directory = {
        truncation_length = 1;
        truncate_to_repo = false;
        style = "bold cyan";
        format = "[$path]($style)";
      };

      git_branch = {
        symbol = "git:";
        style = "bold blue";
        format = "[$symbol\\([$branch](bold red)\\)]($style)";
      };

      git_status = {
        style = "bold red";
        format = " [$all_status$ahead_behind]($style)";
        conflicted = "✗";
        untracked = "✗";
        modified = "✗";
        staged = "✗";
        renamed = "✗";
        deleted = "✗";
        stashed = "✗";
      };
    };
  };
}
