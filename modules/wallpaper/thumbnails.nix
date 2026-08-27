_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.wallpaper.thumbnailManifest = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Path to the prebuilt JSON manifest of wallpaper categories, thumbnails and full-resolution paths. Empty when no aspect provides one.";
        };
      }
    )
  ];

  flake.modules.homeManager.hyprland = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/sessions.md#quickshell-wallpaper-thumbs
        wallpaper.thumbnailManifest = "${import ./_thumbnails.nix {inherit pkgs;}}/manifest.json";
      }
    )
  ];
}
