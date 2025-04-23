{ pkgs, ... }:

{
  programs.ssh.enable = true;

  programs.ssh.extraConfig = ''
    IdentityFile ~/.ssh/id_ed25519
  '';

  programs.git = {
    enable = true;
    userName = "Marcus441";
    userEmail = "psminchia4153@hotmail.com";
  };
}

