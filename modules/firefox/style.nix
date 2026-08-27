_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        ...
      }: let
        c = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors;

        # load-bearing: docs/decisions/firefox.md#chrome-font
        ui = config.gtk.font.name;
      in {
        programs.firefox.profiles.default = {
          # load-bearing: docs/decisions/firefox.md#userchrome-important
          userChrome = ''
            :root {
              /* tab strip and nav-bar are one flat base00 surface. */
              --toolbox-background-color: #${c.base00} !important;
              --toolbox-background-color-inactive: #${c.base00} !important;
              --toolbox-text-color: #${c.base05} !important;
              --toolbox-text-color-inactive: #${c.base04} !important;
              --toolbar-background-color: #${c.base00} !important;
              --toolbar-text-color: #${c.base05} !important;
              --toolbar-color-scheme: dark !important;

              /* base01 is the only raised layer: selected tab, urlbar box. */
              --tab-background-color-selected: #${c.base01} !important;
              --tab-selected-textcolor: #${c.base05} !important;
              --tab-box-shadow-selected: none !important;
              --tab-selected-outline-color: transparent !important;
              --toolbar-field-background-color: #${c.base01} !important;
              --toolbar-field-background-color-focus: #${c.base01} !important;
              --toolbar-field-text-color: #${c.base05} !important;
              --toolbar-field-text-color-focus: #${c.base05} !important;
              --toolbar-field-border-color: #${c.base01} !important;
              --urlbar-box-background-color: #${c.base01} !important;
              --urlbar-box-text-color: #${c.base05} !important;

              /* neutral alpha ladder; no colour cast on a plain hover. */
              --tab-background-color-hover: #${c.base05}14 !important;
              --tab-hover-outline-color: transparent !important;
              --toolbarbutton-background-color-hover: #${c.base05}14 !important;
              --toolbarbutton-background-color-active: #${c.base05}1f !important;
              --toolbarbutton-icon-fill: #${c.base04} !important;

              /* hairlines divide the flat panels; depth is not elevation. */
              --tabs-navbar-separator-color: #${c.base01} !important;
              --tabs-navbar-separator-style: solid !important;
              --chrome-content-separator-color: #${c.base01} !important;

              /* spring blue accent, the colour gtk.nix gives accent_color. */
              --toolbar-field-border-color-focus: #${c.base0D} !important;
              --focus-outline-color: #${c.base0D} !important;
              --tab-attention-dot-color: #${c.base0D} !important;
              --tab-loading-fill: #${c.base0D} !important;
            }

            #navigator-toolbox {
              font-family: "${ui}", sans-serif !important;
            }
          '';

          # load-bearing: docs/decisions/firefox.md#content-backgrounds
          userContent = ''
            :root {
              /* --newtab-* is namespaced, so it needs no fence; hover and
                 overlay derive from the page colour. */
              --newtab-background-color: #${c.base00} !important;
              --newtab-background-color-secondary: #${c.base01} !important;
              --newtab-background-card: #${c.base01} !important;
              --newtab-text-primary-color: #${c.base05} !important;
              --newtab-text-secondary-text: #${c.base04} !important;
              --newtab-primary-action-background: #${c.base0D} !important;
              --newtab-wordmark-color: #${c.base05} !important;
            }

            @-moz-document url-prefix(about:) {
              :root {
                /* generic names a site could own, so these stay fenced. */
                --background-color-canvas: #${c.base00} !important;
                --text-color: #${c.base05} !important;
              }
            }
          '';

          settings = {
            "font.name.sans-serif.x-western" = ui;
            "font.name.serif.x-western" = "Noto Serif";
            "font.name.monospace.x-western" = config.desktop.font.name;
          };
        };
      }
    )
  ];
}
