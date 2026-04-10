{pkgs, ...}: {
  home.packages = with pkgs; [git-graph];
  programs.git = {
    enable = true;
    settings = {
      user.name = "Marcus441";
      user.email = "psminchia4153@hotmail.com";
      url."git@github.com:".insteadOf = "https://github.com/";
      submodule.recurse = true;
    };
  };
}
