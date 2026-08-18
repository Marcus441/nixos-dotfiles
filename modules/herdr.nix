_: {
  flake.modules.homeManager.apps = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        inherit
          (config.desktop.colors16)
          base00
          base01
          base05
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          ;
      in {
        programs.herdr = {
          enable = true;

          settings = {
            onboarding = false;

            theme = {
              name = "kanagawa";
              auto_switch = false;

              # load-bearing: docs/decisions/tui.md#herdr-theme-tokens
              custom = {
                panel_bg = base00;
                surface_dim = base01;
                text = base05;
                accent = base0D;
                blue = base0D;
                teal = base0C;
                green = base0B;
                yellow = base0A;
                peach = base09;
                red = base08;
                mauve = base0E;
              };
            };

            keys.prefix = "ctrl+space";

            ui.toast.delivery = "system";
          };
        };

        # load-bearing: docs/decisions/tui.md#herdr-bare-names
        home.packages = with pkgs; [
          python3Minimal
          libnotify
        ];
      }
    )
  ];
}
