_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.wallpaperMenu.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Shell command that opens the wallpaper picker. Empty when no aspect provides one.";
        };
      }
    )
  ];
}
