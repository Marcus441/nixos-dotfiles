{
  user,
  ...
}: {
  # Shell-agnostic user account. The login shell is set per profile:
  #   fish -> nixos/profiles/maximal/shell.nix
  #   bash -> nixos/profiles/suckless/default.nix
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
  };

  # services.getty.autologinUser = user;
}
