{
  config,
  lib,
  ...
}: {
  programs.zathura = {
    enable = true;
    mappings = {
      D = "toggle_page_mode";
      d = "scroll half_down";
      u = "scroll half_up";
    };
    options = {
      font = "JetBrains Mono Bold 13";

      default-fg = lib.mkForce "#${config.lib.stylix.colors.base05}";
      index-fg = lib.mkForce "#${config.lib.stylix.colors.base05}";

      highlight-active-color = lib.mkForce "rgba(${config.lib.stylix.colors.base0D}, 0.5)";
      highlight-color = lib.mkForce "rgba(${config.lib.stylix.colors.base0D}, 0.5)";

      recolor-lightcolor = lib.mkForce "#${config.lib.stylix.colors.base00}";
      recolor-darkcolor = lib.mkForce "#${config.lib.stylix.colors.base05}";

      adjust-open = "width";
      render-loading = true;
      recolor = true;
    };
  };
}
