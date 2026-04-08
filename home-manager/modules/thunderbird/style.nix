{config, ...}: {
  programs.thunderbird.profiles.default.userChrome = ''
    /* Hide tabs */
    #tabs-toolbar {
      visibility: collapse !important;
    }

    /* Expand card hitboxes */
    tr[is="thread-card"] {
      height: auto !important;
      min-height: 115px !important;
      margin-inline: 0px !important;
      padding: 0px !important;
    }

    /* Card padding and clickability */
    .card-container {
      padding: 12px 16px !important;
      cursor: pointer !important;
    }

    /* Enlarge thread expansion buttons */
    .thread-card-button, .twisty {
      width: 36px !important;
      height: 36px !important;
      margin-right: 10px !important;
    }

    /* Compact unified toolbar */
    #unifiedToolbar {
      padding-block: 1px !important;
      min-height: unset !important;
    }

    /* Increase folder row height */
    .folder-row {
      height: 32px !important;
    }

    /* Strip redundant header labels */
    .message-header-label {
      display: none !important;
    }

    /* Disable focus outlines */
    *:focus-visible {
      outline: none !important;
    }

    /* Force thin scrollbars */
    * {
      scrollbar-width: thin !important;
    }
  '';

  programs.thunderbird.profiles.default.userContent = "";
}
