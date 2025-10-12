{
  pkgs,
  user,
  ...
}: {
  programs.fish.enable = true;

  users = {
    defaultUserShell = pkgs.fish;
    users.${user} = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };

  # services.getty.autologinUser = user;
}
