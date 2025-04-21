{
  programs.starship = {
  enable = true;
  enableZshIntegration = true;
  settings = {
    # Optional: tweak your prompt settings here
    add_newline = false;
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[✗](bold red)";
    };
  };
};
}



