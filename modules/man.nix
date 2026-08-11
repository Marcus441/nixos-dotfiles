_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        inherit (config.desktop) colorsRgb;
        esc = builtins.fromJSON ''"\u001b"'';
      in {
        home.packages = with pkgs; [
          man-pages
          man-pages-posix
        ];

        # load-bearing: docs/decisions/placement.md#man-pager-colours
        home.sessionVariables = {
          GROFF_NO_SGR = 1;
          LESS_TERMCAP_mb = "${esc}[1;38;2;${colorsRgb.base08}m";
          LESS_TERMCAP_md = "${esc}[1;38;2;${colorsRgb.base08}m";
          LESS_TERMCAP_me = "${esc}[0m";
          LESS_TERMCAP_so = "${esc}[38;2;${colorsRgb.base00}m${esc}[48;2;${colorsRgb.base0A}m";
          LESS_TERMCAP_se = "${esc}[0m";
          LESS_TERMCAP_us = "${esc}[4;1;38;2;${colorsRgb.base0B}m";
          LESS_TERMCAP_ue = "${esc}[0m";
          LESS_TERMCAP_mr = "${esc}[7m";
          LESS_TERMCAP_mh = "${esc}[2m";
        };
      }
    )
  ];
}
