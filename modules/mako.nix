{...}: {
  # Same daemon, two theming regimes: palette colours it from desktop.colors,
  # stylix is listed in the stylix target set and colours it itself.
  flake.modules.homeManager.palette = [
    (
      {config, ...}: let
        inherit (config.desktop) colors font;
      in {
        services.mako = {
          enable = true;
          settings = {
            font = "${font.name} ${toString font.size}";
            background-color = colors.base00;
            text-color = colors.base05;
            border-color = colors.base0D;
            border-size = 2;
            padding = 10;
            anchor = "top-right";
            default-timeout = 5000;
          };
        };
      }
    )
  ];

  flake.modules.homeManager.stylix = [
    {
      services.mako = {
        enable = true;

        settings = {
          anchor = "top-right";
          default-timeout = 5000;
          ignore-timeout = false;
          border-size = 2;
          padding = 10;
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
