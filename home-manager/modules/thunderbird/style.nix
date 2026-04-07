{config, ...}: let
  inherit (config.lib.stylix.colors) base00 base01 base02 base03 base04 base05 base06 base07 base08 base09 base0A base0B base0C base0D base0E base0F;
  
  cssVariables = ''
    :root {
      /* Base Colors */
      --base00: #${base00};
      --base01: #${base01};
      --base02: #${base02};
      --base03: #${base03};
      --base04: #${base04};
      --base05: #${base05};
      --base06: #${base06};
      --base07: #${base07};
      --base08: #${base08}; /* Red */
      --base09: #${base09}; /* Orange */
      --base0A: #${base0A}; /* Yellow */
      --base0B: #${base0B}; /* Green */
      --base0C: #${base0C}; /* Cyan */
      --base0D: #${base0D}; /* Blue */
      --base0E: #${base0E}; /* Purple */
      --base0F: #${base0F}; /* Brown */

      /* App-wide standard variables */
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
      
      --button-background-color: var(--base01) !important;
      --button-hover-background-color: var(--base02) !important;
      --button-active-background-color: var(--base03) !important;
      
      --input-background-color: var(--base01) !important;
      --input-color: var(--base05) !important;
      --input-border-color: var(--base03) !important;
      
      --listbox-background: var(--base00) !important;
      --listbox-color: var(--base05) !important;

      --chrome-background-color: var(--base00) !important;
      --chrome-color: var(--base05) !important;

      --lwt-tab-text: var(--base05) !important;
      --lwt-selected-tab-background-color: var(--base01) !important;
    }
  '';
in {
  programs.thunderbird.profiles.default.userChrome = ''
    /* Base16 Theme for Thunderbird Supernova (115+) */
    
    '' + cssVariables + ''

    /* Global Scrollbars */
    * {
      scrollbar-color: var(--base02) var(--base00) !important;
      scrollbar-width: thin !important;
    }

    /* Window, Body and Dialogs */
    window, page, dialog, wizard, preferences, #messengerWindow {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      font-family: "Inter", sans-serif !important;
      font-size: 13pt !important;
    }

    /* Toolbars & Spaces Toolbar */
    toolbox, toolbar, .toolbar-primary, #mail-toolbox, #header-view-toolbox, #composeToolbox, #spacesToolbar, #spacesPinned, #unifiedToolbarContainer, #quick-filter-bar {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      border: none !important;
      appearance: none !important;
    }

    /* Hide the tab bar as requested previously */
    #tabs-toolbar {
      visibility: collapse !important;
    }

    /* Spaces Toolbar specific buttons */
    #spacesPinnedButton {
      fill: var(--base05) !important;
      color: var(--base05) !important;
    }
    
    .spaces-button {
      background-color: transparent !important;
      color: var(--base05) !important;
    }
    .spaces-button:hover {
      background-color: var(--base01) !important;
    }
    .spaces-button[checked="true"] {
      background-color: var(--base02) !important;
      color: var(--base0D) !important;
    }

    /* --- FOLDER PANE (Left Sidebar) --- */
    #folderPane, #folderTree {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      appearance: none !important;
      border: none !important;
    }

    /* Folder pane items */
    #folderTree li > .container {
      background-color: transparent !important;
      color: var(--base05) !important;
    }

    /* Hovered Folder */
    #folderTree li:hover > .container {
      background-color: var(--base01) !important;
    }

    /* Selected Folder */
    #folderTree li.selected > .container {
      background-color: var(--base02) !important;
      color: var(--base05) !important;
    }

    /* Unread Folder */
    #folderTree li.unread > .container > .name {
      color: var(--base0D) !important;
      font-weight: bold !important;
    }

    /* New Messages Folder */
    #folderTree li.new-messages > .container > .name {
      color: var(--base0B) !important;
      font-weight: bold !important;
    }

    /* Today Pane (Calendar Sidebar) */
    #today-pane-panel, #minimonth-pane, .minimonth {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      border-left: 1px solid var(--base02) !important;
    }

    /* --- MESSAGE LIST (Thread Pane) --- */
    #threadTree, .tree-table, .tree-view {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      border: none !important;
    }

    /* Table headers in thread pane */
    .tree-table-header, treecol {
      background-color: var(--base01) !important;
      color: var(--base04) !important;
      border: none !important;
      border-bottom: 1px solid var(--base02) !important;
      border-right: 1px solid var(--base02) !important;
      appearance: none !important;
    }
    
    treecol:hover {
      background-color: var(--base02) !important;
    }

    /* Message Row Default */
    tr[is="thread-row"] {
      background-color: transparent !important;
      color: var(--base05) !important;
    }

    /* Message Row Hover */
    tr[is="thread-row"]:hover {
      background-color: var(--base01) !important;
    }

    /* Message Row Selected */
    tr[is="thread-row"].selected,
    tr[is="thread-row"].selected:hover {
      background-color: var(--base02) !important;
      color: var(--base05) !important;
    }

    /* Unread Message Row */
    tr[is="thread-row"][data-properties~="unread"] {
      color: var(--base0D) !important;
      font-weight: bold !important;
    }
    
    tr[is="thread-row"][data-properties~="new"] {
      color: var(--base0B) !important;
    }

    /* Message Tags */
    tr[is="thread-row"] .tag-text {
      color: var(--base0A) !important;
    }

    /* --- MESSAGE HEADER VIEW (Reading Pane Top) --- */
    #msgHeaderView, .message-header-view {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border: none !important;
      border-bottom: 1px solid var(--base02) !important;
    }

    #msgHeaderView .header-name {
      color: var(--base0D) !important;
    }

    #msgHeaderView .header-value {
      color: var(--base05) !important;
    }

    /* --- SEARCH BAR AND INPUTS --- */
    input, textarea, menulist {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border: 1px solid var(--base02) !important;
      border-radius: 4px !important;
      appearance: none !important;
    }
    
    input:focus, textarea:focus, menulist:focus {
      border-color: var(--base0D) !important;
    }

    /* Checkboxes and Radios */
    checkbox .checkbox-check, radio .radio-check {
      appearance: none !important;
      background-color: var(--base01) !important;
      border: 1px solid var(--base02) !important;
    }
    checkbox[checked="true"] .checkbox-check, radio[selected="true"] .radio-check {
      background-color: var(--base0D) !important;
      border-color: var(--base0D) !important;
    }

    /* --- BUTTONS --- */
    button, .button {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border: 1px solid var(--base02) !important;
      border-radius: 4px !important;
      appearance: none !important;
    }

    button:hover, .button:hover {
      background-color: var(--base02) !important;
    }

    button.primary {
      background-color: var(--base0D) !important;
      color: var(--base00) !important;
      border-color: var(--base0D) !important;
    }

    /* --- MENUS AND POPUPS --- */
    menupopup, panel, popup {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      border: 1px solid var(--base02) !important;
      appearance: none !important;
    }

    menuitem, menu {
      color: var(--base05) !important;
      appearance: none !important;
    }

    menuitem[_moz-menuactive="true"], menu[_moz-menuactive="true"],
    menuitem:hover, menu:hover {
      background-color: var(--base02) !important;
      color: var(--base05) !important;
    }

    /* --- COMPOSER WINDOW --- */
    #msgcomposeWindow {
      background-color: var(--base00) !important;
    }

    #headers-box {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border-bottom: 1px solid var(--base02) !important;
    }

    /* Splitters */
    splitter {
      background-color: var(--base02) !important;
      border: none !important;
      width: 2px !important;
    }
    
    /* Scrollbars (if supported using pseudo elements) */
    scrollbar {
      background-color: var(--base00) !important;
      appearance: none !important;
    }
    slider {
      background-color: var(--base00) !important;
    }
    thumb {
      background-color: var(--base02) !important;
      border-radius: 4px !important;
    }
    thumb:hover {
      background-color: var(--base03) !important;
    }
  '';

  programs.thunderbird.profiles.default.userContent = ''
    /* Base16 Theme for Internal Pages (Preferences, Add-ons, Message Body background) */
    
    '' + cssVariables + ''

    /* Global Scrollbars */
    * {
      scrollbar-color: var(--base02) var(--base00) !important;
      scrollbar-width: thin !important;
    }

    /* Apply base background to message bodies and settings pages */
    body, html, .main-content, #dialogFrame {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
      font-family: "Inter", sans-serif !important;
    }

    /* Links */
    a {
      color: var(--base0D) !important;
    }
    
    a:hover {
      color: var(--base0C) !important;
    }

    /* Preferences page sections */
    groupbox {
      background-color: var(--base01) !important;
      border: 1px solid var(--base02) !important;
      border-radius: 6px !important;
      padding: 10px !important;
      margin-bottom: 15px !important;
    }

    /* Plain text emails (often viewed in a specific container) */
    .moz-text-plain, .moz-text-flowed {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
    }
    
    blockquote {
      border-left: 3px solid var(--base0D) !important;
      color: var(--base04) !important;
    }

    /* Inputs, Buttons inside content pages */
    input, textarea, select {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border: 1px solid var(--base02) !important;
      border-radius: 4px !important;
      padding: 4px !important;
    }
    
    button {
      background-color: var(--base01) !important;
      color: var(--base05) !important;
      border: 1px solid var(--base02) !important;
      border-radius: 4px !important;
      padding: 4px 8px !important;
      cursor: pointer !important;
    }
    
    button:hover {
      background-color: var(--base02) !important;
    }
    
    button.primary {
      background-color: var(--base0D) !important;
      color: var(--base00) !important;
    }

    /* Empty state messages */
    .empty-folder-image, #accountCentral {
      background-color: var(--base00) !important;
      color: var(--base05) !important;
    }
  '';
}
