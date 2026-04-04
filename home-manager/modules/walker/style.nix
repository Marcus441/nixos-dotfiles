{config}: ''
  @define-color base00 #${config.lib.stylix.colors.base00};
  @define-color base0D #${config.lib.stylix.colors.base0D};
  @define-color base05 #${config.lib.stylix.colors.base05};
  @define-color base08 #${config.lib.stylix.colors.base08};

  /* =========================================
     1. GLOBAL STYLES
     ========================================= */
  * {
    all: unset;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 18px;
    color: @base05;
  }

  scrollbar { opacity: 0; }
  .normal-icons { -gtk-icon-size: 16px; }
  .large-icons { -gtk-icon-size: 32px; }

  /* =========================================
     2. MAIN WINDOW & LAYOUT
     ========================================= */
  .box-wrapper {
    background: alpha(@base00, 0.95);
    padding: 20px;
    border: 2px solid @base0D;
    box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3);
  }

  .search-container {
    background: @base00;
    padding: 10px;
  }

  .input {
    caret-color: @base05;
    padding: 10px;
  }

  .input placeholder { opacity: 0.5; }

  .placeholder {
    font-size: 18px;
    opacity: 0.5;
    margin-top: 20px;
  }

  .error {
    padding: 10px;
    background: @base08;
    color: @base05;
  }

  /* =========================================
     3. DEFAULT LIST ITEMS
     ========================================= */
  .item-box { padding: 15px 14px; }
  .item-text-box { all: unset; padding: 14px 0; }

  child:selected .item-box {
    background: alpha(@base0D, 0.25);
  }
  child:selected .item-box * {
    color: @base05;
  }

  .item-subtext {
    font-size: 0px;
    min-height: 0px;
    margin: 0px;
    padding: 0px;
  }

  .item-image {
    margin-right: 14px;
    -gtk-icon-transform: scale(0.9);
  }

  /* =========================================
     4. CALCULATOR SPECIFIC ITEMS
     ========================================= */
  .calc-box {
    background: alpha(@base0D, 0.1);
    border-radius: 8px;
    margin: 5px 0;
  }

  .calc-text {
    font-size: 32px;
    font-weight: bold;
    color: @base0D;
  }

  .calc-subtext {
    font-size: 16px;
    opacity: 0.5;
  }

  /* =========================================
     5. PREVIEW PANE & INNER CONTENT
     ========================================= */
  .preview-window {
    background: alpha(@base00, 0.5);
    border-left: 2px solid alpha(@base0D, 0.3);
    padding: 15px;
    min-width: 400px; /* Forces window to expand */
  }

  .preview-image {
    -gtk-icon-transform: scale(1.5);
    margin-bottom: 15px;
  }

  .preview-text {
    font-size: 20px;
    font-weight: bold;
    color: @base05;
  }

  .preview-subtext {
    font-size: 14px;
    opacity: 0.7;
    margin-top: 10px;
  }

  /* =========================================
     6. KEYBINDS HINT BAR
     ========================================= */
  #Keybinds {
    border-top: 1px solid alpha(@base0D, 0.2);
    padding-top: 8px;
  }

  #Keybinds label {
    font-size: 12px;
    color: @base05;
    opacity: 0.6;
  }

  .keybind-key {
    font-weight: bold;
    color: @base0D;
    margin-right: 4px;
  }

  .item-quick-activation {
    font-size: 10px;
    padding: 2px 4px;
    background: alpha(@base0D, 0.1);
    border-radius: 3px;
    margin-left: 10px;
  }
''
