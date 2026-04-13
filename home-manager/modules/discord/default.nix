{
  pkgs,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [equibop];
    file = {
      ".config/equibop/settings.json".source = ./equibop-settings.json;
      ".config/equibop/settings/settings.json".source =
        ./equibop-plugin-settings.json;
      ".config/equibop/settings/quickCss.css".text = ''
        .theme-dark {
          /* ── backgrounds ── */
          --background-base-lower:      #${config.lib.stylix.colors.base00};
          --background-base-low:        #${config.lib.stylix.colors.base01};
          --background-primary:         #${config.lib.stylix.colors.base01};
          --background-secondary:       #${config.lib.stylix.colors.base01};
          --background-secondary-alt:   #${config.lib.stylix.colors.base01};
          --background-tertiary:        #${config.lib.stylix.colors.base00};
          --background-surface-high:    #${config.lib.stylix.colors.base02};
          --background-surface-higher:  #${config.lib.stylix.colors.base02};
          --background-surface-highest: #${config.lib.stylix.colors.base03};
          --background-floating:        #${config.lib.stylix.colors.base01};
          --background-modifier-hover:  #${config.lib.stylix.colors.base0D}1a;
          --background-modifier-active: #${config.lib.stylix.colors.base0D}33;
          --background-modifier-selected: #${config.lib.stylix.colors.base0D}26;
          --background-modifier-accent: #${config.lib.stylix.colors.base03};
          --channeltextarea-background: #${config.lib.stylix.colors.base02};
          --modal-background:           #${config.lib.stylix.colors.base01};
          --modal-footer-background:    #${config.lib.stylix.colors.base00};
          --card-background-default:    #${config.lib.stylix.colors.base02};
          --bg-overlay-2:               #${config.lib.stylix.colors.base01};
          --bg-surface-raised:          #${config.lib.stylix.colors.base02};

          /* ── text ── */
          --text-normal:    #${config.lib.stylix.colors.base05};
          --text-default:   #${config.lib.stylix.colors.base05};
          --text-muted:     #${config.lib.stylix.colors.base04};
          --text-subtle:    #${config.lib.stylix.colors.base03};
          --text-strong:    #${config.lib.stylix.colors.base06};
          --text-link:      #${config.lib.stylix.colors.base0D};
          --text-brand:     #${config.lib.stylix.colors.base0D};
          --text-positive:  #${config.lib.stylix.colors.base0B};
          --text-warning:   #${config.lib.stylix.colors.base0A};
          --text-danger:    #${config.lib.stylix.colors.base08};
          --header-primary:   #${config.lib.stylix.colors.base06};
          --header-secondary: #${config.lib.stylix.colors.base04};

          /* ── icons ── */
          --icon-default:  #${config.lib.stylix.colors.base04};
          --icon-muted:    #${config.lib.stylix.colors.base03};
          --icon-strong:   #${config.lib.stylix.colors.base06};
          --icon-subtle:   #${config.lib.stylix.colors.base03};
          --icon-link:     #${config.lib.stylix.colors.base0D};

          /* ── interactive ── */
          --interactive-normal:  #${config.lib.stylix.colors.base04};
          --interactive-hover:   #${config.lib.stylix.colors.base05};
          --interactive-active:  #${config.lib.stylix.colors.base06};
          --interactive-muted:   #${config.lib.stylix.colors.base03};

          /* ── borders ── */
          --border-faint:  #${config.lib.stylix.colors.base02};
          --border-subtle: #${config.lib.stylix.colors.base01};
          --border-normal: #${config.lib.stylix.colors.base01};
          --border-strong: #${config.lib.stylix.colors.base04};
          --border-focus:  #${config.lib.stylix.colors.base0D};

          /* ── brand / accent ── */
          --brand-500:              #${config.lib.stylix.colors.base0D};
          --brand-experiment:       #${config.lib.stylix.colors.base0D};
          --brand-experiment-400:   #${config.lib.stylix.colors.base0D};
          --brand-experiment-500:   #${config.lib.stylix.colors.base0D};
          --brand-experiment-560:   #${config.lib.stylix.colors.base0D};
          --background-brand:       #${config.lib.stylix.colors.base0D};
          --control-brand-foreground: #${config.lib.stylix.colors.base0D};
          --control-brand-foreground-new: #${config.lib.stylix.colors.base0D};

          /* ── status ── */
          --status-positive:            #${config.lib.stylix.colors.base0B};
          --status-positive-background: #${config.lib.stylix.colors.base0B}33;
          --status-positive-text:       #${config.lib.stylix.colors.base0B};
          --status-warning:             #${config.lib.stylix.colors.base0A};
          --status-warning-background:  #${config.lib.stylix.colors.base0A}33;
          --status-warning-text:        #${config.lib.stylix.colors.base0A};
          --status-danger:              #${config.lib.stylix.colors.base08};
          --status-danger-background:   #${config.lib.stylix.colors.base08}33;
          --status-danger-text:         #${config.lib.stylix.colors.base08};

          /* ── channels / chat ── */
          --channels-default:         #${config.lib.stylix.colors.base04};
          --channel-icon:             #${config.lib.stylix.colors.base03};
          --chat-background:          #${config.lib.stylix.colors.base01};
          --chat-background-default:  #${config.lib.stylix.colors.base01};

          /* ── inputs ── */
          --input-background:        #${config.lib.stylix.colors.base01};
          --input-background-default: #${config.lib.stylix.colors.base01};
          --input-border:            #${config.lib.stylix.colors.base03};
          --input-border-default:    #${config.lib.stylix.colors.base03};
          --input-border-hover:      #${config.lib.stylix.colors.base04};
          --input-border-active:     #${config.lib.stylix.colors.base0D};
          --input-placeholder-text-default: #${config.lib.stylix.colors.base03};
          --input-text-default:      #${config.lib.stylix.colors.base05};

          /* ── scrollbars ── */
          --scrollbar-thin-thumb:  #${config.lib.stylix.colors.base03};
          --scrollbar-thin-track:  transparent;
          --scrollbar-auto-thumb:  #${config.lib.stylix.colors.base03};
          --scrollbar-auto-track:  #${config.lib.stylix.colors.base01};

          /* ── mentions / highlights ── */
          --mention-background:   #${config.lib.stylix.colors.base0D}1a;
          --mention-foreground:   #${config.lib.stylix.colors.base0D};
          --message-highlight-background-default: #${config.lib.stylix.colors.base0A}1a;
          --message-mentioned-background-default: #${config.lib.stylix.colors.base0D}1a;

          /* ── legacy vars (still referenced by some elements) ── */
          --primary-530: #${config.lib.stylix.colors.base01};
          --primary-600: #${config.lib.stylix.colors.base02};
          --primary-630: #${config.lib.stylix.colors.base02};
          --primary-700: #${config.lib.stylix.colors.base02};
          --primary-730: #${config.lib.stylix.colors.base03};
          --primary-800: #${config.lib.stylix.colors.base00};
        }
      '';
    };
  };
}
