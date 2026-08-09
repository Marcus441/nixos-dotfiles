_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit (config.desktop) colors;

        # load-bearing: docs/decisions/theming.md#qt-roleorder
        roleOrder = [
          "WindowText"
          "Button"
          "Light"
          "Midlight"
          "Dark"
          "Mid"
          "Text"
          "BrightText"
          "ButtonText"
          "Base"
          "Window"
          "Shadow"
          "Highlight"
          "HighlightedText"
          "Link"
          "LinkVisited"
          "AlternateBase"
          "NoRole"
          "ToolTipBase"
          "ToolTipText"
          "PlaceholderText"
        ];

        argb = c: "#ff${lib.removePrefix "#" c}";
        row = roles: lib.concatMapStringsSep ", " (r: argb roles.${r}) roleOrder;

        active = {
          WindowText = colors.base05;
          Button = colors.base01;
          Light = colors.base03;
          Midlight = colors.base02;
          Dark = colors.base00;
          Mid = colors.base02;
          Text = colors.base05;
          BrightText = colors.base07;
          ButtonText = colors.base05;
          Base = colors.base00;
          Window = colors.base00;
          Shadow = colors.base10;
          Highlight = colors.base0D;
          HighlightedText = colors.base00;
          Link = colors.base0D;
          LinkVisited = colors.base0E;
          AlternateBase = colors.base01;
          NoRole = colors.base00;
          ToolTipBase = colors.base01;
          ToolTipText = colors.base05;
          PlaceholderText = colors.base04;
        };

        disabled =
          active
          // {
            WindowText = colors.base03;
            Text = colors.base03;
            BrightText = colors.base03;
            ButtonText = colors.base03;
            PlaceholderText = colors.base03;
            Highlight = colors.base02;
            HighlightedText = colors.base04;
          };

        colorScheme = pkgs.writeText "palette.conf" ''
          [ColorScheme]
          active_colors=${row active}
          disabled_colors=${row disabled}
          inactive_colors=${row active}
        '';

        # load-bearing: docs/decisions/theming.md#qt-font
        qfont = family: size: ''"${family},${toString size},-1,5,50,0,0,0,0,0"'';

        conf = ''
          [Appearance]
          custom_palette=true
          color_scheme_path=${colorScheme}
          icon_theme=${config.gtk.iconTheme.name}
          standard_dialogs=default
          style=Fusion

          [Fonts]
          general=${qfont config.gtk.font.name config.gtk.font.size}
          fixed=${qfont config.desktop.font.name config.desktop.font.size}
        '';
      in {
        qt = {
          enable = true;
          # load-bearing: docs/decisions/theming.md#qt-platformtheme
          platformTheme.name = "qtct";
        };

        xdg.configFile = {
          "qt5ct/qt5ct.conf".text = conf;
          "qt6ct/qt6ct.conf".text = conf;
        };
      }
    )
  ];
}
