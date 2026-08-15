{
  flake.modules.homeManager.apps = [
    {
      programs.thunderbird.profiles.default.userChrome = ''
        #tabs-toolbar {
          visibility: collapse !important;
        }

        tr[is="thread-card"] {
          height: auto !important;
          min-height: 115px !important;
          margin-inline: 0px !important;
          padding: 0px !important;
        }

        .card-container {
          padding: 12px 16px !important;
          cursor: pointer !important;
        }

        .thread-card-button, .twisty {
          width: 36px !important;
          height: 36px !important;
          margin-right: 10px !important;
        }

        #unifiedToolbar {
          padding-block: 1px !important;
          min-height: unset !important;
        }

        .folder-row {
          height: 32px !important;
        }

        .message-header-label {
          display: none !important;
        }

        *:focus-visible {
          outline: none !important;
        }

        * {
          scrollbar-width: thin !important;
        }
      '';

      programs.thunderbird.profiles.default.userContent = "";
    }
  ];
}
