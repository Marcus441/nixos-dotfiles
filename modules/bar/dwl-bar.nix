_: {
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

        buildInputs = [pkgs.fcft pkgs.libdrm];
      };
    })
  ];

  flake.modules.nixos.dwl-bar = [
    {
      # load-bearing: docs/decisions/sessions.md#dwl-bar-status
      dwl.statusCommand = "while :; do date '+%a %d %b  %H:%M'; sleep 30; done";
    }
  ];
}
