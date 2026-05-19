{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "yes";
      SetEnv = {
        TERM = "xterm-256color";
      };
    };
  };
}
