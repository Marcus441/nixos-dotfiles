{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Marcus441";
      user.email = "psminchia4153@hotmail.com";
      "url.git@github.com:".insteadOf = "https://github.com/";
      submodule.recurse = true;
      submodule.url = "git@github.com:";
      core.sshCommand = "ssh -i /home/marcus/.ssh/id_ed25519";
    };
  };
}
