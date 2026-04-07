{config, ...}: let
  inherit (config.lib.stylix.colors) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
  
  cssVariables = ''
    :root, :host {
      /* Base Colors */
      --base00: #${base00};
      --base01: #${base01};
      --base02: #${base02};
      --base03: #${base03};
      --base04: #${base04};
      --base05: #${base05};
      --base06: #${base06};
      --base07: #${base07};
      --base08: #${base08};
      --base09: #${base09};
      --base0A: #${base0A};
      --base0B: #${base0B};
      --base0C: #${base0C};
      --base0D: #${base0D};
      --base0E: #${base0E};
      --base0F: #${base0F};

      /* Override Mozilla Bolt Design System Variables */
      
      /* Surfaces */
      --color-surface-base: var(--base00) !important;
      --color-surface-subtle: var(--base01) !important;
      --color-surface-border: var(--base02) !important;
      --color-surface-border-intense: var(--base03) !important;
      --color-surface-lower: var(--base00) !important;
      --color-surface-deep: var(--base01) !important;
      --color-surface-raised: var(--base01) !important;

      /* Primary (Brand/Accent) */
      --color-primary-soft: var(--base02) !important;
      --color-primary-default: var(--base0D) !important;
      --color-primary-hover: var(--base0C) !important;
      --color-primary-pressed: var(--base0E) !important;

      /* Secondary */
      --color-secondary-soft: var(--base02) !important;
      --color-secondary-default: var(--base0E) !important;
      --color-secondary-hover: var(--base0D) !important;
      --color-secondary-pressed: var(--base0C) !important;

      /* Success */
      --color-success-soft: var(--base02) !important;
      --color-success-default: var(--base0B) !important;
      --color-success-hover: var(--base0B) !important;
      --color-success-pressed: var(--base0B) !important;

      /* Warning */
      --color-warning-soft: var(--base02) !important;
      --color-warning-default: var(--base0A) !important;
      --color-warning-hover: var(--base09) !important;
      --color-warning-pressed: var(--base09) !important;

      /* Critical */
      --color-critical-soft: var(--base02) !important;
      --color-critical-default: var(--base08) !important;
      --color-critical-hover: var(--base08) !important;
      --color-critical-pressed: var(--base08) !important;

      /* Text */
      --color-text-base: var(--base05) !important;
      --color-text-secondary: var(--base04) !important;
      --color-text-muted: var(--base03) !important;
      --color-text-highlight: var(--base0D) !important;
      --color-text-warning: var(--base0A) !important;
      --color-text-critical: var(--base08) !important;
      --color-text-success: var(--base0B) !important;

      /* Accents */
      --color-accent-teal: var(--base0C) !important;
      --color-accent-blue: var(--base0D) !important;
      --color-accent-purple: var(--base0E) !important;
      --color-accent-orange: var(--base09) !important;
      --color-accent-pink: var(--base0F) !important;
      --color-accent-ink: var(--base04) !important;
      
      /* Dark variants explicit overrides just in case standard overrides miss context */
      --color-surface-base-dark: var(--base00) !important;
      --color-surface-raised-dark: var(--base01) !important;
      --color-surface-subtle-dark: var(--base01) !important;
      --color-surface-deep-dark: var(--base02) !important;
      --color-surface-border-dark: var(--base02) !important;
      --color-surface-border-intense-dark: var(--base03) !important;
      --color-surface-lower-dark: var(--base00) !important;
      --color-primary-default-dark: var(--base0D) !important;
      --color-text-base-dark: var(--base05) !important;
      --color-text-secondary-dark: var(--base04) !important;
      --color-text-muted-dark: var(--base03) !important;

      /* Light variants explicit overrides (if forced light in some frame) */
      --color-surface-base-light: var(--base00) !important;
      --color-surface-raised-light: var(--base01) !important;
      --color-surface-subtle-light: var(--base01) !important;
      --color-surface-deep-light: var(--base02) !important;
      --color-surface-border-light: var(--base02) !important;
      --color-surface-border-intense-light: var(--base03) !important;
      --color-surface-lower-light: var(--base00) !important;
      --color-primary-default-light: var(--base0D) !important;
      --color-text-base-light: var(--base05) !important;
      --color-text-secondary-light: var(--base04) !important;
      --color-text-muted-light: var(--base03) !important;

      /* Legacy / Specific variable overrides */
      --lwt-accent-color: var(--base00) !important;
      --lwt-text-color: var(--base05) !important;
      --toolbar-bgcolor: var(--base00) !important;
      --toolbar-color: var(--base05) !important;
      --toolbar-field-background-color: var(--base01) !important;
      --toolbar-field-color: var(--base05) !important;
      --toolbar-field-focus-background-color: var(--base02) !important;
      --toolbar-field-focus-border-color: var(--base0D) !important;
      --sidebar-background-color: var(--base00) !important;
      --sidebar-text-color: var(--base05) !important;
      --sidebar-highlight-background-color: var(--base02) !important;
      --sidebar-highlight-text-color: var(--base05) !important;
      --in-content-page-background: var(--base00) !important;
      --in-content-page-color: var(--base05) !important;
    }
  '';
in {
  programs.thunderbird.profiles.default.userChrome = ''
    /* Base16 Theme for Thunderbird using Bolt Variables */
    '' + cssVariables + ''

    /* Global Scrollbars */
    * {
      scrollbar-color: var(--base02) var(--base00) !important;
      scrollbar-width: thin !important;
    }

    /* Base Typography and explicit backgrounds for legacy frames */
    window, page, dialog, wizard, preferences, #messengerWindow {
      background-color: var(--color-surface-base) !important;
      color: var(--color-text-base) !important;
      font-family: "Inter", sans-serif !important;
      font-size: 13pt !important;
    }

    /* Hide the tab bar as requested */
    #tabs-toolbar {
      visibility: collapse !important;
    }
    
    /* Tree cols (some stubborn legacy elements) */
    treecol {
      background-color: var(--color-surface-subtle) !important;
      color: var(--color-text-secondary) !important;
      border: none !important;
      border-bottom: 1px solid var(--color-surface-border) !important;
      border-right: 1px solid var(--color-surface-border) !important;
      appearance: none !important;
    }
  '';

  programs.thunderbird.profiles.default.userContent = ''
    /* Base16 Theme for Internal Pages using Bolt Variables */
    '' + cssVariables + ''

    /* Global Scrollbars */
    * {
      scrollbar-color: var(--base02) var(--base00) !important;
      scrollbar-width: thin !important;
    }

    /* Apply base background to message bodies and settings pages */
    body, html, .main-content, #dialogFrame {
      background-color: var(--color-surface-base) !important;
      color: var(--color-text-base) !important;
      font-family: "Inter", sans-serif !important;
    }

    /* Plain text emails */
    .moz-text-plain, .moz-text-flowed {
      background-color: var(--color-surface-base) !important;
      color: var(--color-text-base) !important;
    }
    
    blockquote {
      border-left: 3px solid var(--color-primary-default) !important;
      color: var(--color-text-secondary) !important;
    }
  '';
}
