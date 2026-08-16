_: {
  flake.modules.homeManager.hyprland = [
    (
      {
        config,
        lib,
        ...
      }: let
        # load-bearing: docs/decisions/sessions.md#hyprland-rules-regex
        tagRules = lib.concatLists (
          lib.mapAttrsToList (
            tag: classes:
              lib.imap0 (i: class: {
                name = "tag-${tag}-${toString i}";
                match = {inherit class;};
                tag = "+${tag}";
              })
              (lib.unique classes)
          )
          config.windowTags
        );
      in {
        wayland.windowManager.hyprland.settings = {
          window_rule =
            [
              {
                name = "suppress-maximize";
                match = {class = ".*";};
                suppress_event = "maximize";
              }
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
                size = "1200 760";
              }
              {
                name = "no-anim";
                match = {tag = "no-anim";};
                no_anim = true;
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
              name = "no-anim-wleave";
              match = {namespace = "wleave";};
              no_anim = true;
            }
          ];
        };
      }
    )
  ];
}
