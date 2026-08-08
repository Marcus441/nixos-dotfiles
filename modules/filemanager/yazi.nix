_: {
  flake.modules.homeManager.apps = [
    (
      {
        pkgs,
        config,
        ...
      }: let
        inherit (config.desktop) colors;
      in {
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";

          settings = {
            plugin = {
              prepend_fetchers = [
                {
                  url = "*";
                  run = "git";
                  group = "git";
                }
                {
                  url = "*/";
                  run = "git";
                  group = "git";
                }
              ];
            };
          };

          # Only what the preset gets wrong for this palette. Everything absent
          # here is yazi's own, which names ANSI colours and so already reads
          # `desktop.colors` through foot.
          #
          # A partial theme merges onto the preset, so a background is only
          # cleared by naming one. Which name depends on whether anything reads
          # it back: `reset` where the style is only ever drawn, base00 where a
          # component uses the background as a foreground -- see `mode` below.
          theme = {
            mgr = {
              marker_marked = {
                fg = "lightcyan";
                bg = "lightcyan";
              };
              tab_width = 1;
              syntect_theme = "${config.desktop.syntaxTheme}";

              # Preset `gray` is ANSI 7, which foot maps to base06 -- brighter
              # than the text it frames.
              border_style.fg = colors.base0D;
            };

            confirm.border.fg = colors.base0D;
            cmp.border.fg = colors.base0D;
            input.border.fg = colors.base0D;
            pick.border.fg = colors.base0D;
            spot.border.fg = colors.base0D;
            tasks.border.fg = colors.base0D;

            indicator = {
              padding = {
                open = "▐";
                close = "▌";
              };

              # The preview pane's last hover is preset `underline = true`,
              # which cuts through the descenders of the very filenames it is
              # marking. A background carries the same information and leaves
              # the glyphs alone.
              preview = {
                underline = false;
                bg = colors.base02;
              };
            };

            # tmux's status vocabulary: transparent behind everything, one
            # reversed chip, colour carried by the foreground. `_main` is the
            # chip, `_alt` the separator caps and the segment after it.
            #
            # `_alt.bg` is base00 rather than `reset` because status.lua reads
            # it as a *foreground*: `ui.Span(sep_left.close):fg(style.alt:bg())`
            # draws the transition out of the size segment. A `reset` there is
            # the default text colour, which is a base05 bar in the middle of
            # the bar. base00 is the same value foot.nix gives the terminal
            # background, so it renders as nothing.
            mode = {
              normal_main = {
                fg = colors.base00;
                bg = colors.base0D;
                bold = true;
              };
              normal_alt = {
                fg = colors.base0D;
                bg = colors.base00;
              };
              select_main = {
                fg = colors.base00;
                bg = colors.base0B;
                bold = true;
              };
              select_alt = {
                fg = colors.base0B;
                bg = colors.base00;
              };
              unset_main = {
                fg = colors.base00;
                bg = colors.base08;
                bold = true;
              };
              unset_alt = {
                fg = colors.base08;
                bg = colors.base00;
              };
            };

            status = {
              sep_left = {
                open = "▐";
                close = "▌";
              };
              sep_right = {
                open = "▐";
                close = "▌";
              };

              # Preset paints these on solid `black` and `red` blocks.
              progress_normal = {
                fg = colors.base0D;
                bg = "reset";
              };
              progress_error = {
                fg = colors.base08;
                bg = "reset";
              };
            };

            which = {
              cols = 3;
              separator = "  ";
            };

            # A rule with no `fg` takes the file's own colour, and `filetype`
            # names ANSI -- so the palette decides. Dropping the preset's 14
            # named-folder rules leaves `conds` as the only source of directory
            # icons; restated here because a list is replaced, not merged.
            icon = {
              dirs = [];
              conds = [
                {
                  "if" = "orphan";
                  text = "";
                }
                {
                  "if" = "link";
                  text = "";
                }
                {
                  "if" = "block";
                  text = "";
                }
                {
                  "if" = "char";
                  text = "";
                }
                {
                  "if" = "fifo";
                  text = "";
                }
                {
                  "if" = "sock";
                  text = "";
                }
                {
                  "if" = "sticky";
                  text = "";
                }
                {
                  "if" = "dummy";
                  text = "";
                }
                {
                  "if" = "dir & hovered";
                  text = "";
                }
                {
                  "if" = "dir";
                  text = "";
                }
                {
                  "if" = "exec";
                  text = "";
                }
                {
                  "if" = "!dir";
                  text = "";
                }
              ];
            };
          };

          plugins = {
            inherit (pkgs.yaziPlugins) git;
          };

          initLua = ''
            require("git"):setup()
          '';
        };
      }
    )
  ];
}
