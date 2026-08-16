_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        # load-bearing: docs/decisions/gaming.md#mangohud-fhs
        programs.steam.extraPackages = [pkgs.mangohud];
      }
    )
  ];

  flake.modules.homeManager.gaming = [
    (
      {fontSize, ...}: {
        programs.mangohud = {
          enable = true;
          settings = {
            fps = true;
            frametime = true;
            frame_timing = 1;
            gpu_stats = true;
            gpu_temp = true;
            cpu_stats = true;
            cpu_temp = true;
            ram = true;
            vram = true;
            position = "top-left";
            font_size = fontSize;
            toggle_hud = "Shift_R+F12";
          };
        };
      }
    )
  ];
}
