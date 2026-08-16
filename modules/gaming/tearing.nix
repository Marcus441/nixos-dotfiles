_: let
  gameClass = "^(steam_app_\\d+|gamescope)$";
in {
  # load-bearing: docs/decisions/gaming.md#tearing-intersection
  aspectRequires.tearing = ["gaming" "hyprland"];

  flake.modules.homeManager.gaming = [
    {windowTags.no-anim = [gameClass];}
  ];

  flake.modules.homeManager.tearing = [
    {
      wayland.windowManager.hyprland.settings = {
        config = {
          general.allow_tearing = true;
          render.direct_scanout = 1;
        };

        window_rule = [
          {
            name = "game-immediate";
            match = {class = gameClass;};
            immediate = true;
            content = "game";
            idle_inhibit = "fullscreen";
          }
        ];
      };
    }
  ];
}
