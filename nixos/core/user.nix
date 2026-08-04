{
  pkgs,
  user,
  ...
}: {
  # bash is the login shell on every host (interactive config in
  # home-manager/core/bash.nix). Profiles no longer set a shell.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.bashInteractive;
  };

  # services.getty.autologinUser = user;
}
