_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: let
        # One rule per regex rather than one alternation: the regexes arrive from
        # separate files, so joining them would mean wrapping each in a group the
        # contributing file cannot see it needs.
        tagRules = lib.concatLists (
          lib.mapAttrsToList (
            tag: classes:
              lib.imap0 (i: class: {
                name = "tag-${tag}-${toString i}";
                match = {inherit class;};
                tag = "+${tag}";
              })
              # Two files naming the same window would otherwise each emit a
              # rule adding the same tag.
              (lib.unique classes)
          )
          config.windowTags
        );
      in {
        wayland.windowManager.hyprland.settings = {
          window_rule =
            [
              # Maximize suppression
              {
                name = "suppress-maximize";
                match = {class = ".*";};
                suppress_event = "maximize";
              }
              # Fix blank unclickable Xwayland components
              {
                name = "no-focus-empty-xwayland";
                match = {
                  class = "^$";
                  title = "^$";
                  xwayland = true;
                  float = true;
                  fullscreen = false;
                  pin = false;
                };
                no_focus = true;
              }
              # Xwaylandvideobridge
              {
                name = "xwvb";
                match = {class = "^(xwaylandvideobridge)$";};
                opacity = 0.0;
                no_anim = true;
                no_initial_focus = true;
                max_size = "1 1";
                no_blur = true;
                no_focus = true;
              }
            ]
            ++ tagRules
            # Apply behaviors onto custom matching window tags
            ++ [
              {
                name = "floating-float";
                match = {tag = "floating-window";};
                float = true;
              }
              {
                name = "floating-center";
                match = {tag = "floating-window";};
                center = true;
              }
              {
                name = "floating-size";
                match = {tag = "floating-window";};
                size = "1200 600";
              }
              {
                name = "no-anim";
                match = {tag = "no-anim";};
                no_anim = true;
              }
              # Smart gaps (Zero constraints when single window matches tiled criteria)
              {
                name = "no-gaps-wtv1";
                match = {
                  float = false;
                  workspace = "w[tv1]";
                };
                border_size = 0;
                rounding = 0;
              }
              {
                name = "no-gaps-f1";
                match = {
                  float = false;
                  workspace = "f[1]";
                };
                border_size = 0;
                rounding = 0;
              }
            ];

          workspace_rule = [
            {
              workspace = "f[1]";
              gaps_out = 0;
              gaps_in = 0;
            }
            {
              workspace = "w[tv1]";
              gaps_out = 0;
              gaps_in = 0;
            }
          ];

          layer_rule = [
            {
              name = "no-anim-selection";
              match = {namespace = "selection";};
              no_anim = true;
            }
            {
              name = "no-anim-walker";
              match = {namespace = "walker";};
              no_anim = true;
            }
          ];
        };
      }
    )
  ];
}
