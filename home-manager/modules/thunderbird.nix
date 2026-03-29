{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.default = {
      isDefault = true;
      settings = {
        "mail.spellcheck.inline" = true;
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

        /* Make the interface font cleaner */
        * {
          font-family: "Inter", sans-serif !important;
          font-size: 10pt !important;
        }
      '';
    };
  };
}
