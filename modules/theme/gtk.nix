_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        inherit (config.desktop) colors;

        # load-bearing: docs/decisions/theming.md#gtk-adw
        paletteCss = ''
          @define-color accent_color ${colors.base0D};
          @define-color accent_bg_color ${colors.base0D};
          @define-color accent_fg_color ${colors.base00};
          @define-color destructive_color ${colors.base08};
          @define-color destructive_bg_color ${colors.base08};
          @define-color destructive_fg_color ${colors.base00};
          @define-color success_color ${colors.base0B};
          @define-color success_bg_color ${colors.base0B};
          @define-color success_fg_color ${colors.base00};
          @define-color warning_color ${colors.base0A};
          @define-color warning_bg_color ${colors.base0A};
          @define-color warning_fg_color ${colors.base00};
          @define-color error_color ${colors.base08};
          @define-color error_bg_color ${colors.base08};
          @define-color error_fg_color ${colors.base00};

          @define-color window_bg_color ${colors.base00};
          @define-color window_fg_color ${colors.base05};
          @define-color view_bg_color ${colors.base00};
          @define-color view_fg_color ${colors.base05};

          @define-color headerbar_bg_color ${colors.base01};
          @define-color headerbar_fg_color ${colors.base05};
          @define-color headerbar_backdrop_color @window_bg_color;
          @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
          @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);

          @define-color sidebar_bg_color ${colors.base01};
          @define-color sidebar_fg_color ${colors.base05};
          @define-color sidebar_backdrop_color @window_bg_color;
          @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);
          @define-color secondary_sidebar_bg_color @sidebar_bg_color;
          @define-color secondary_sidebar_fg_color @sidebar_fg_color;
          @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
          @define-color secondary_sidebar_shade_color @sidebar_shade_color;

          @define-color card_bg_color ${colors.base01};
          @define-color card_fg_color ${colors.base05};
          @define-color card_shade_color rgba(0, 0, 0, 0.07);
          @define-color dialog_bg_color ${colors.base01};
          @define-color dialog_fg_color ${colors.base05};
          @define-color popover_bg_color ${colors.base01};
          @define-color popover_fg_color ${colors.base05};
          @define-color popover_shade_color rgba(0, 0, 0, 0.07);
          @define-color shade_color rgba(0, 0, 0, 0.07);
          @define-color scrollbar_outline_color ${colors.base02};

          @define-color blue_1 ${colors.base0D};
          @define-color blue_2 ${colors.base0D};
          @define-color blue_3 ${colors.base0D};
          @define-color blue_4 ${colors.base0D};
          @define-color blue_5 ${colors.base0D};
          @define-color green_1 ${colors.base0B};
          @define-color green_2 ${colors.base0B};
          @define-color green_3 ${colors.base0B};
          @define-color green_4 ${colors.base0B};
          @define-color green_5 ${colors.base0B};
          @define-color yellow_1 ${colors.base0A};
          @define-color yellow_2 ${colors.base0A};
          @define-color yellow_3 ${colors.base0A};
          @define-color yellow_4 ${colors.base0A};
          @define-color yellow_5 ${colors.base0A};
          @define-color orange_1 ${colors.base09};
          @define-color orange_2 ${colors.base09};
          @define-color orange_3 ${colors.base09};
          @define-color orange_4 ${colors.base09};
          @define-color orange_5 ${colors.base09};
          @define-color red_1 ${colors.base08};
          @define-color red_2 ${colors.base08};
          @define-color red_3 ${colors.base08};
          @define-color red_4 ${colors.base08};
          @define-color red_5 ${colors.base08};
          @define-color purple_1 ${colors.base0E};
          @define-color purple_2 ${colors.base0E};
          @define-color purple_3 ${colors.base0E};
          @define-color purple_4 ${colors.base0E};
          @define-color purple_5 ${colors.base0E};
          @define-color brown_1 ${colors.base0F};
          @define-color brown_2 ${colors.base0F};
          @define-color brown_3 ${colors.base0F};
          @define-color brown_4 ${colors.base0F};
          @define-color brown_5 ${colors.base0F};
          @define-color light_1 ${colors.base05};
          @define-color light_2 ${colors.base05};
          @define-color light_3 ${colors.base05};
          @define-color light_4 ${colors.base05};
          @define-color light_5 ${colors.base05};
          @define-color dark_1 ${colors.base01};
          @define-color dark_2 ${colors.base01};
          @define-color dark_3 ${colors.base01};
          @define-color dark_4 ${colors.base00};
          @define-color dark_5 ${colors.base00};
        '';
      in {
        gtk = {
          enable = true;

          gtk3.extraCss = paletteCss;
          gtk4.extraCss = paletteCss;

          theme = {
            name = "adw-gtk3-dark";
            package = pkgs.adw-gtk3;
          };

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };

          font = {
            name = "Inter";
            size = 11;
            package = pkgs.inter;
          };

          gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
          gtk4.theme = null;
        };

        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      }
    )
  ];

  flake.modules.nixos.core = [
    {
      programs.dconf.enable = true;
    }
  ];
}
