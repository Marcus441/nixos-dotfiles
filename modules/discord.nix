_: {
  flake.modules.homeManager.apps = [
    (
      {
        pkgs,
        config,
        lib,
        ...
      }: let
        c = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors;
      in {
        # equibop ships equibop.desktop; the association still named
        # vesktop.desktop, which nothing here installs.
        xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "equibop.desktop";

        home = {
          packages = with pkgs; [equibop];
          file = {
            ".config/equibop/settings.json".source = ./discord/equibop-settings.json;
            ".config/equibop/settings/settings.json".source =
              ./discord/equibop-plugin-settings.json;
            ".config/equibop/settings/quickCss.css".text = ''
              .theme-dark {
                /* ── backgrounds ── */
                --background-base-lower:      #${c.base00};
                --background-base-low:        #${c.base01};
                --background-primary:         #${c.base01};
                --background-secondary:       #${c.base01};
                --background-secondary-alt:   #${c.base01};
                --background-tertiary:        #${c.base00};
                --background-surface-high:    #${c.base02};
                --background-surface-higher:  #${c.base02};
                --background-surface-highest: #${c.base03};
                --background-floating:        #${c.base01};
                --background-modifier-hover:  #${c.base0D}1a;
                --background-modifier-active: #${c.base0D}33;
                --background-modifier-selected: #${c.base0D}26;
                --background-modifier-accent: #${c.base03};
                --channeltextarea-background: #${c.base02};
                --modal-background:           #${c.base01};
                --modal-footer-background:    #${c.base00};
                --card-background-default:    #${c.base02};
                --bg-overlay-2:               #${c.base01};
                --bg-surface-raised:          #${c.base02};

                /* ── text ── */
                --text-normal:    #${c.base05};
                --text-default:   #${c.base05};
                --text-muted:     #${c.base04};
                --text-subtle:    #${c.base03};
                --text-strong:    #${c.base06};
                --text-link:      #${c.base0D};
                --text-brand:     #${c.base0D};
                --text-positive:  #${c.base0B};
                --text-warning:   #${c.base0A};
                --text-danger:    #${c.base08};
                --header-primary:   #${c.base06};
                --header-secondary: #${c.base04};

                /* ── icons ── */
                --icon-default:  #${c.base04};
                --icon-muted:    #${c.base03};
                --icon-strong:   #${c.base06};
                --icon-subtle:   #${c.base03};
                --icon-link:     #${c.base0D};

                /* ── interactive ── */
                --interactive-normal:  #${c.base04};
                --interactive-hover:   #${c.base05};
                --interactive-active:  #${c.base06};
                --interactive-muted:   #${c.base03};

                /* ── borders ── */
                --border-faint:  #${c.base02};
                --border-subtle: #${c.base01};
                --border-normal: #${c.base01};
                --border-strong: #${c.base04};
                --border-focus:  #${c.base0D};

                /* ── brand / accent ── */
                --brand-500:              #${c.base0D};
                --brand-experiment:       #${c.base0D};
                --brand-experiment-400:   #${c.base0D};
                --brand-experiment-500:   #${c.base0D};
                --brand-experiment-560:   #${c.base0D};
                --background-brand:       #${c.base0D};
                --control-brand-foreground: #${c.base0D};
                --control-brand-foreground-new: #${c.base0D};

                /* ── status ── */
                --status-positive:            #${c.base0B};
                --status-positive-background: #${c.base0B}33;
                --status-positive-text:       #${c.base0B};
                --status-warning:             #${c.base0A};
                --status-warning-background:  #${c.base0A}33;
                --status-warning-text:        #${c.base0A};
                --status-danger:              #${c.base08};
                --status-danger-background:   #${c.base08}33;
                --status-danger-text:         #${c.base08};

                /* ── channels / chat ── */
                --channels-default:         #${c.base04};
                --channel-icon:             #${c.base03};
                --chat-background:          #${c.base01};
                --chat-background-default:  #${c.base01};

                /* ── inputs ── */
                --input-background:        #${c.base01};
                --input-background-default: #${c.base01};
                --input-border:            #${c.base03};
                --input-border-default:    #${c.base03};
                --input-border-hover:      #${c.base04};
                --input-border-active:     #${c.base0D};
                --input-placeholder-text-default: #${c.base03};
                --input-text-default:      #${c.base05};

                /* ── scrollbars ── */
                --scrollbar-thin-thumb:  #${c.base03};
                --scrollbar-thin-track:  transparent;
                --scrollbar-auto-thumb:  #${c.base03};
                --scrollbar-auto-track:  #${c.base01};

                /* ── mentions / highlights ── */
                --mention-background:   #${c.base0D}1a;
                --mention-foreground:   #${c.base0D};
                --message-highlight-background-default: #${c.base0A}1a;
                --message-mentioned-background-default: #${c.base0D}1a;

                /* ── legacy vars (still referenced by some elements) ── */
                --primary-530: #${c.base01};
                --primary-600: #${c.base02};
                --primary-630: #${c.base02};
                --primary-700: #${c.base02};
                --primary-730: #${c.base03};
                --primary-800: #${c.base00};
              }
            '';
          };
        };
      }
    )
  ];
}
