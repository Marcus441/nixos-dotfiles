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
        xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "equibop.desktop";

        home = {
          packages = with pkgs; [equibop];
          file = {
            ".config/equibop/settings.json".source = ./discord/equibop-settings.json;
            ".config/equibop/settings/settings.json".source =
              ./discord/equibop-plugin-settings.json;
            ".config/equibop/settings/quickCss.css".text = ''
              .theme-dark {
                /* ── window ─────────────────────────────────────────────
                   flat base00 everywhere; base01 only for raised layers
                   (popouts, modals' cards, the composer). depth comes from
                   hairline borders, not elevation. */
                --background-base-lowest:     #${c.base00};
                --background-base-lower:      #${c.base00};
                --background-base-low:        #${c.base00};
                --background-primary:         #${c.base00};
                --background-secondary:       #${c.base00};
                --background-secondary-alt:   #${c.base00};
                --background-tertiary:        #${c.base00};
                --home-background:            #${c.base00};
                --chat-background:            #${c.base00};
                --chat-background-default:    #${c.base00};
                --background-mobile-primary:  #${c.base00};
                --background-mobile-secondary: #${c.base00};

                --background-surface-high:    #${c.base01};
                --background-surface-higher:  #${c.base01};
                --background-surface-highest: #${c.base01};
                --background-floating:        #${c.base01};
                --background-nested-floating: #${c.base01};
                --bg-surface-raised:          #${c.base01};
                --bg-overlay-2:               #${c.base00};
                --card-background-default:    #${c.base01};
                --activity-card-background:   #${c.base01};
                --channeltextarea-background: #${c.base01};
                --modal-background:           #${c.base00};
                --modal-footer-background:    #${c.base00};

                /* ── separation ────────────────────────────────────────
                   hairlines at base01 divide the flat panels; base03 only
                   where a border must be obvious. focus ring is accent. */
                --border-faint:  #${c.base01};
                --border-subtle: #${c.base01};
                --border-normal: #${c.base01};
                --border-strong: #${c.base03};
                --border-focus:  #${c.base0D};
                --focus-primary: #${c.base0D};

                /* ── interaction states ────────────────────────────────
                   neutral white-alpha ladder: hover 8% → active 12% →
                   selected 16%. no colour cast on plain interactions. */
                --background-modifier-hover:    #${c.base05}14;
                --background-modifier-active:   #${c.base05}1f;
                --background-modifier-selected: #${c.base05}29;
                --background-modifier-accent:   #${c.base01};
                --background-message-hover:     #${c.base05}0a;

                /* ── text ──────────────────────────────────────────────
                   base05 body, base04 secondary, base03 tertiary.
                   headers use base06 (old white) for kanagawa warmth. */
                --text-normal:    #${c.base05};
                --text-default:   #${c.base05};
                --text-muted:     #${c.base04};
                --text-subtle:    #${c.base03};
                --text-strong:    #${c.base07};
                --header-primary:   #${c.base06};
                --header-secondary: #${c.base04};
                --text-link:      #${c.base16};
                --text-brand:     #${c.base0D};
                --text-positive:  #${c.base14};
                --text-warning:   #${c.base13};
                --text-danger:    #${c.base12};

                /* ── icons ─────────────────────────────────────────────*/
                --icon-default:  #${c.base04};
                --icon-muted:    #${c.base03};
                --icon-subtle:   #${c.base03};
                --icon-strong:   #${c.base06};
                --icon-link:     #${c.base16};

                --interactive-normal:  #${c.base04};
                --interactive-hover:   #${c.base05};
                --interactive-active:  #${c.base07};
                --interactive-muted:   #${c.base03};
                --channels-default:    #${c.base04};
                --channel-icon:        #${c.base03};

                /* ── controls ──────────────────────────────────────────
                   inputs sit on the window colour with a visible border;
                   secondary buttons are raised base01 with the same
                   neutral hover ladder as everything else. */
                --input-background:         #${c.base00};
                --input-background-default: #${c.base00};
                --input-border:             #${c.base03};
                --input-border-default:     #${c.base03};
                --input-border-hover:       #${c.base04};
                --input-border-active:      #${c.base0D};
                --input-placeholder-text-default: #${c.base03};
                --input-text-default:       #${c.base05};

                --button-secondary-background:        #${c.base01};
                --button-secondary-background-hover:  #${c.base05}1f;
                --button-secondary-background-active: #${c.base05}29;
                --button-danger-background:           #${c.base08};
                --button-danger-background-hover:     #${c.base12};
                --button-positive-background:         #${c.base0B};
                --button-positive-background-hover:   #${c.base14};

                /* ── accent ────────────────────────────────────────────
                   spring blue base0D at rest, crystal blue base16 on
                   hover — the base24 bright is the interactive step. */
                --brand-500:              #${c.base0D};
                --brand-experiment:       #${c.base0D};
                --brand-experiment-400:   #${c.base16};
                --brand-experiment-500:   #${c.base0D};
                --brand-experiment-560:   #${c.base0D};
                --background-brand:       #${c.base0D};
                --control-brand-foreground:     #${c.base0D};
                --control-brand-foreground-new: #${c.base0D};
                --mention-background:   #${c.base0D}1a;
                --mention-foreground:   #${c.base16};
                --message-mentioned-background-default: #${c.base0D}1a;
                --message-highlight-background-default: #${c.base0A}1a;

                /* ── status ────────────────────────────────────────────
                   muted base16 hues for fills and dots, base24 brights
                   for text sitting on the alpha-tinted backgrounds. */
                --status-positive:            #${c.base0B};
                --status-positive-background: #${c.base0B}33;
                --status-positive-text:       #${c.base14};
                --status-warning:             #${c.base0A};
                --status-warning-background:  #${c.base0A}33;
                --status-warning-text:        #${c.base13};
                --status-danger:              #${c.base08};
                --status-danger-background:   #${c.base08}33;
                --status-danger-text:         #${c.base12};

                /* ── scrollbars ────────────────────────────────────────*/
                --scrollbar-thin-thumb:  #${c.base01};
                --scrollbar-thin-track:  transparent;
                --scrollbar-auto-thumb:  #${c.base01};
                --scrollbar-auto-track:  #${c.base00};

                /* ── legacy grayscale ramp ─────────────────────────────
                   old selectors still read these; lower = lighter. */
                --primary-500: #${c.base04};
                --primary-530: #${c.base03};
                --primary-600: #${c.base01};
                --primary-630: #${c.base01};
                --primary-660: #${c.base00};
                --primary-700: #${c.base00};
                --primary-730: #${c.base00};
                --primary-800: #${c.base00};
              }
            '';
          };
        };
      }
    )
  ];
}
