_: {
  flake.modules.homeManager.core = [
    (
      {config, ...}: let
        inherit (config.desktop) colors;

        # load-bearing: docs/decisions/theming.md#zathura-alpha
        translucent = c: "${c}80";
      in {
        programs.zathura = {
          enable = true;
          options = {
            selection-clipboard = "clipboard";
            adjust-open = "best-fit";
            pages-per-row = 1;
            scroll-step = 50;
            zoom-min = 10;
            zoom-step = 10;
            render-loading = false;
            scroll-full-overlap = "0.01";

            default-bg = colors.base00;
            default-fg = colors.base01;
            statusbar-bg = colors.base02;
            statusbar-fg = colors.base04;
            inputbar-bg = colors.base00;
            inputbar-fg = colors.base05;

            notification-bg = colors.base00;
            notification-fg = colors.base05;
            notification-error-bg = colors.base00;
            notification-error-fg = colors.base08;
            notification-warning-bg = colors.base00;
            notification-warning-fg = colors.base0A;

            completion-bg = colors.base01;
            completion-fg = colors.base0D;
            completion-highlight-bg = colors.base0D;
            completion-highlight-fg = colors.base05;

            highlight-color = translucent colors.base0A;
            highlight-active-color = translucent colors.base0D;

            recolor-lightcolor = colors.base00;
            recolor-darkcolor = colors.base06;
          };
          mappings = {
            "u" = "scroll half-up";
            "d" = "scroll half-down";
            "j" = "scroll down";
            "k" = "scroll up";
            "h" = "scroll left";
            "l" = "scroll right";
            "gg" = "goto top";
            "G" = "goto bottom";
            "J" = "navigate next";
            "K" = "navigate previous";
            "+" = "zoom in";
            "-" = "zoom out";
            "=" = "zoom original";
            "i" = "recolor";
            "D" = "toggle_page_mode";
            "r" = "reload";
            "R" = "rotate";
            "f" = "toggle_fullscreen";
            "<Space>" = "scroll half-down";
            "<S-Space>" = "scroll half-up";
          };
        };
      }
    )
  ];
}
