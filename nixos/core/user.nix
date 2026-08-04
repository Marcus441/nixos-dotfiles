{
  pkgs,
  user,
  ...
}: {
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.bashInteractive;
  };
}
