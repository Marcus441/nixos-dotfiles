_: {
  flake.modules.homeManager.dwl = [
    {
      services.mako = {
        enable = true;

        settings = {
          anchor = "top-right";
          default-timeout = 5000;
          border-size = 2;
          padding = 10;
        };

        extraConfig = ''
          [app-name=notify-send summary="OCR*"]
          default-timeout=3000

          [summary="*screenshot*"]
          default-timeout=5000
        '';
      };
    }

    (
      {config, ...}: let
        inherit (config.desktop) colors font;
      in {
        services.mako.settings = {
          font = "${font.name} ${toString font.terminalSize}";
          background-color = colors.base00;
          text-color = colors.base05;
          border-color = colors.base0D;

          ignore-timeout = false;
          max-icon-size = 32;
          outer-margin = 20;
          width = 420;
          height = 110;

          progress-color = "over ${colors.base02}";
        };

        services.mako.extraConfig = ''
          [urgency=critical]
          background-color=${colors.base00}
          border-color=${colors.base08}
          text-color=${colors.base05}

          [urgency=low]
          background-color=${colors.base00}
          border-color=${colors.base03}
          text-color=${colors.base05}
        '';
      }
    )
  ];

  flake.modules.homeManager.laptop = [
    {
      services.mako.extraConfig = ''
        [summary="*Battery*"]
        default-timeout=20000
      '';
    }
  ];
}
