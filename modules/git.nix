{...}: {
  # The GitHub CLI is system-wide because it was; only its home changed.
  flake.modules.nixos.core = [
    ({pkgs, ...}: {environment.systemPackages = [pkgs.gh];})
  ];

  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [git-graph];
        programs.git = {
          enable = true;
          settings = {
            user.name = "Marcus441";
            user.email = "88486170+Marcus441@users.noreply.github.com";
            url."git@github.com:".insteadOf = "https://github.com/";
            submodule.recurse = true;
          };
        };
      }
    )
  ];
}
