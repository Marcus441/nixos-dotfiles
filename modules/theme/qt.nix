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

        # QPalette::ColorRole enum order. qt5ct/qt6ct write the 21 roles as one
        # positional list, so the order is the format -- not a preference.
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

        # The palette carries no alpha; Qt wants ARGB.
        argb = c: "#ff${lib.removePrefix "#" c}";
        row = roles: lib.concatMapStringsSep ", " (r: argb roles.${r}) roleOrder;

        # Flat surfaces base00, raised ones base01 -- the same split gtk.nix
        # makes between window_bg_color and headerbar/card/popover.
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

        # Fusion derives its shading from the QPalette, so it is the one style
        # that shows the scheme above. adwaita-qt hardcoded GNOME's colours and
        # ignored it. Deliberately not set via `qt.style.name`: that exports
        # QT_STYLE_OVERRIDE, which wins over these files and would split the
        # decision across two places.
        # QFont::toString's legacy 10-field form, which Qt 6 still parses. The
        # quotes are load-bearing: QSettings splits an unquoted value on commas
        # and would hand qt6ct a QStringList instead of a font.
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
          # "adwaita" installs qadwaitadecorations -- Wayland decorations, not a
          # QPA platform theme. It still exported QT_QPA_PLATFORMTHEME=adwaita,
          # which resolved to no plugin, so Qt apps silently took no icon theme
          # and no font. qtct ships a real platformthemes plugin; both qt5ct's
          # and qt6ct's declare the keys `qt5ct` and `qt6ct`, so the single
          # QT_QPA_PLATFORMTHEME=qt5ct that Home Manager exports covers Qt 5 and 6.
          platformTheme.name = "qtct";
        };

        # The icon theme is gtk.nix's decision; reading it is what keeps the two
        # toolkits from drifting to different icon sets.
        xdg.configFile = {
          "qt5ct/qt5ct.conf".text = conf;
          "qt6ct/qt6ct.conf".text = conf;
        };
      }
    )
  ];
}
