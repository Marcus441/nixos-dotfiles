{config}: ''
  @define-color base00 #${config.lib.stylix.colors.base00};
  @define-color base0D #${config.lib.stylix.colors.base0D};
  @define-color base05 #${config.lib.stylix.colors.base05};
  @define-color base08 #${config.lib.stylix.colors.base08};

  * {
    all: unset;
    font-family: "JetBrainsMono Nerd Font";
    font-size: 18px;
    color: @base05;
  }

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

  scrollbar { opacity: 0; }
  .normal-icons { -gtk-icon-size: 16px; }
  .large-icons { -gtk-icon-size: 32px; }
  .preview-window {
    background: alpha(@base00, 0.5);
    border-left: 2px solid alpha(@base0D, 0.3);
    padding: 15px;
    color: @base05;
    font-size: 14px;
  }

  .preview-window label {
    all: unset;
    font-family: monospace;
    font-size: 14px;
    wrap: true;
  }

  .item-box {
    padding: 15px 10px;
  }

  .placeholder {
    font-size: 18px;
    opacity: 0.5;
    margin-top: 20px;
  }
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

  child:selected .item-box {
    background: alpha(@base0D, 0.25);
  }

  child:selected .item-box * {
    color: @base05;
  }

  .item-box { padding-left: 14px; padding: 10px; }

  .item-text-box { all: unset; padding: 14px 0; }

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

  .error {
    padding: 10px;
    background: @base08;
    color: @base05;
  }
''
