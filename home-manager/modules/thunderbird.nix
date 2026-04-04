{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.default = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "mail.spellcheck.inline" = true;
        "network.protocol-handler.warn-external.http" = true;
        "network.protocol-handler.warn-external.https" = true;
        "extensions.autoDisableScopes" = 0;

        "mailnews.default_view_flags" = 1;
        "mailnews.default_sort_type" = 18;
        "mailnews.default_sort_order" = 2;

        "font.name.sans-serif.x-western" = "Inter";
        "font.size.variable.x-western" = 16;
      };

      userChrome = ''
        /* Hide the tab bar */
        #tabs-toolbar {
          visibility: collapse !important;
        }

        /* Targeted UI Font Change */
        :root,
        #messengerWindow,
        #mail-toolbox,
        .tabmail-tab,
        #folderPane,
        #threadTree {
            font-family: "Inter", sans-serif !important;
            font-size: 13pt !important;
        }
      '';
    };
  };
}
