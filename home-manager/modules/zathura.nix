{
  programs.zathura = {
    enable = true;
    options = {
      font = "JetBrains Mono Bold 13";
      selection-clipboard = "clipboard";
      adjust-open = "best-fit";
      pages-per-row = 1;
      scroll-step = 50;
      zoom-min = 10;
      zoom-step = 10;
      render-loading = false;
      page-padding = 1;
      scroll-full-overlap = "0.01";
      fastrender = true;
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
