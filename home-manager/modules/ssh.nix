{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      extraOptions.SetEnv = "TERM=xterm-256color";
    };
  };
}
