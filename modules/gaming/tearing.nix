_: let
  gameClass = "^(steam_app_\\d+|gamescope)$";
in {
  aspectRequires.tearing = ["gaming" "mango"];

  flake.modules.homeManager.gaming = [
    {windowTags.no-anim = [gameClass];}
  ];

  flake.modules.homeManager.tearing = [
    {
      # TODO: Move to mango

      # wayland.windowManager.hyprland.settings = {
      #   config = {
      #     general.allow_tearing = true;
      #     render.direct_scanout = 1;
      #   };
      #
      #   window_rule = [
      #     {
      #       name = "game-immediate";
      #       match = {class = gameClass;};
      #       immediate = true;
      #       content = "game";
      #       idle_inhibit = "fullscreen";
      #     }
      #   ];
      # };
    }
  ];
}
