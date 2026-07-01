{
  pkgs,
  user,
  ...
}: {
  # fish is the maximal login shell. Enabling it system-wide adds it to
  # /etc/shells (a prerequisite for setting it as a login shell) and provides
  # the vendor completions. The interactive fish config lives in the maximal
  # *home* profile (home-manager/profiles/maximal/fish.nix).
  programs.fish.enable = true;
  users.users.${user}.shell = pkgs.fish;
}
