{
  config,
  pkgs,
  ...
}: {
  programs.ssh.enable = true;
  services.ssh-agent.enable = true;
  programs.ssh.addKeysToAgent = "yes";
  programs.ssh.extraConfig = ''
    IdentityFile ~/.ssh/id_ed25519
  '';

  programs.git = {
    enable = true;
    userName = "Marcus441";
    userEmail = "psminchia4153@hotmail.com";
    extraConfig = {
      # Set Git to use SSH instead of HTTPS for GitHub URLs
      "url.git@github.com:".insteadOf = "https://github.com/";
      # Ensure submodules use SSH as well
      submodule.recurse = "true";
      submodule.url = "git@github.com:";
      core.sshCommand = "ssh -i /home/marcus/.ssh/id_ed25519";
    };
  };
}
