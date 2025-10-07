{
  programs.zathura = {
    enable = true;
    mappings = {
      D = "toggle_page_mode";
      d = "scroll half_down";
      u = "scroll half_up";
    };
    options = {
      font = "JetBrains Mono Bold 13";
      default-bg = "#1D1C19";
      default-fg = "#C5C9C5";
      index-bg = "#1D1C19";
      index-fg = "#C5C9C5";

      highlight-active-color = "rgba(139, 164, 176, 0.5)";
      highlight-color = "rgba(139, 164, 176, 0.5)";

      recolor-lightcolor = "#1D1C19";
      recolor-darkcolor = "#C5C9C5";

      adjust-open = "width";
      render-loading = true;
      recolor = true;
    };
  };
}
