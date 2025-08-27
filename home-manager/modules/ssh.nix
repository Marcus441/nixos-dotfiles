{
  programs.ssh = {
    enable = true;
    services.ssh-agent.enable = true;
    enableDefaultConfig = false; # prevent future default removal issues

    matchBlocks."*" = {
      addKeysToAgent = true;
      IdentityFile = "~/.ssh/id_ed25519";
      # you can add other options here
    };
  };
}
