{...}: {
  flake.modules.homeManager.suckless = [
    (
      {pkgs, ...}: {
        config = {
          home.packages = [
            pkgs.nerd-fonts.iosevka-term
            pkgs.noto-fonts
            pkgs.noto-fonts-color-emoji
            pkgs.dejavu_fonts
          ];
          fonts.fontconfig.enable = true;
        };
      }
    )
  ];
}
