_: let
  # Placement and timing hold under either regime; only colour and geometry
  # differ, so each branch below shows just what makes it different.
  shared = {
    anchor = "top-right";
    default-timeout = 5000;
    border-size = 2;
    padding = 10;
  };
in {
  # Same daemon, two theming regimes: palette colours it from desktop.colors,
  # stylix is listed in the stylix target set and colours it itself.
  flake.modules.homeManager.palette = [
    (
      {config, ...}: let
        inherit (config.desktop) colors font;
      in {
        services.mako = {
          enable = true;
          settings =
            shared
            // {
              font = "${font.name} ${toString font.size}";
              background-color = colors.base00;
              text-color = colors.base05;
              border-color = colors.base0D;
            };
        };
      }
    )
  ];

  flake.modules.homeManager.stylix = [
    {
      services.mako = {
        enable = true;

        # Geometry is deliberately not shared. These override mako's defaults
        # (max-icon-size 64, outer-margin 0, width 300, height 100) for the
        # 1440p and 4K desktops; swift5's 1080p panel keeps the defaults.
        settings =
          shared
          // {
            ignore-timeout = false;
            max-icon-size = 32;
            outer-margin = 20;
            width = 420;
            height = 110;
          };
        extraConfig = ''
          [app-name=notify-send summary="OCR*"]
          default-timeout=3000

          [summary="*Battery*"]
          default-timeout=20000

          [summary="*screenshot*"]
          default-timeout=5000
        '';
      };
    }
  ];
}
