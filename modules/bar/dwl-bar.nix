_: {
  # dwl's config.h is compiled, not read at runtime, and the patch below is what
  # defines `showbar`, `tags[]`, `SchemeNorm` and the `Clk*` regions the `dwl`
  # aspect renders against `dwl.bar`. A host taking this without `dwl` would set
  # options nothing reads; a host taking `dwl` and expecting a bar without this
  # would not compile. Both are the same dependency, declared once.
  aspectRequires.dwl-bar = ["dwl"];

  flake.modules.homeManager.dwl-bar = [
    ({pkgs, ...}: {
      dwl = {
        bar = true;

        patches = [
          (pkgs.fetchpatch {
            name = "dwl-bar.patch";
            url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/bar/bar.patch";
            hash = "sha256-guW5Gan9jg5S8O7F/LfvQpUJy7Cgs8ly89peL7YazeI=";
          })
        ];

        # drwl.h draws glyphs through fcft and takes its DRM_FORMAT constants
        # from libdrm; neither is a dependency of unpatched dwl.
        buildInputs = [pkgs.fcft pkgs.libdrm];
      };
    })
  ];

  flake.modules.nixos.dwl-bar = [
    {
      # The bar reads its status text from dwl's stdin, and the session script
      # holding that pipe is in the nixos half, which cannot see homeManager
      # config. So the feed crosses as a nixos option instead -- one file, two
      # classes, the same shape as filemanager/thunar.nix.
      dwl.statusCommand = "while :; do date '+%a %d %b  %H:%M'; sleep 30; done";
    }
  ];
}
