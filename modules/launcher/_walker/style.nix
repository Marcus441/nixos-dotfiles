{
  colors,
  font,
}: ''
  @define-color base00 #${colors.base00};
  @define-color base01 #${colors.base01};
  @define-color base02 #${colors.base02};
  @define-color base03 #${colors.base03};
  @define-color base05 #${colors.base05};
  @define-color base0D #${colors.base0D};
  @define-color base08 #${colors.base08};

  * {
    all: unset;
    font-family: '${font}', 'Symbols Nerd Font Mono', monospace;
    font-size: 18px;
    color: @base05;
  }

  popover {
    background: @base00;
    border: 1px solid @base02;
    border-radius: 0;
    padding: 8px;
  }

  scrollbar { opacity: 0; }
  .normal-icons { -gtk-icon-size: 16px; }
  .large-icons { -gtk-icon-size: 32px; }

  .box-wrapper {
    background: @base00;
    border: 2px solid @base0D;
    border-radius: 0;
    box-shadow: none;
    padding: 0;
    overflow: hidden;
  }

  .search-container {
    background: transparent;
    padding: 14px 18px;
    border-bottom: 1px solid @base01;
  }

  .search-icon {
    color: @base0D;
    -gtk-icon-size: 22px;
  }

  .input {
    font-size: 28px;
    caret-color: @base0D;
    background: transparent;
    color: @base05;
    padding: 2px 0;
  }

  .input placeholder {
    color: @base03;
  }

  .input selection {
    background: @base0D;
    color: @base00;
  }

  .input:focus,
  .input:active {
  }

  .content-container {
  }

  .scroll {
  }

  .list {
    color: @base05;
    padding: 0;
  }

  .placeholder,
  .elephant-hint {
    color: @base03;
    font-size: 13px;
    padding: 20px;
  }

  child {
  }

  .item-box {
    padding: 6px 14px;
    border-radius: 0;
    min-height: 44px;
  }

  /* A quiet fill, not the accent -- the bar's inactive-workspace chip. */
  child:selected .item-box,
  row:selected .item-box {
    background: @base02;
    border-radius: 0;
  }

  .item-text-box {
  }

  .item-text {
    font-size: 18px;
  }

  .item-subtext {
    font-size: 14px;
    color: @base03;
  }

  .item-image-text {
    font-size: 28px;
  }

  .item-quick-activation {
    background: @base02;
    color: @base05;
    border-radius: 0;
    padding: 4px 8px;
    font-size: 11px;
  }

  /* Would vanish into the selected row, which is @base02 itself. */
  child:selected .item-quick-activation,
  row:selected .item-quick-activation {
    background: @base03;
    color: @base00;
  }

  .preview {
    color: @base05;
    border-left: 1px solid @base01;
    border-radius: 0;
  }

  .preview-box {
    color: @base05;
  }

  .preview .large-icons {
    -gtk-icon-size: 64px;
  }

  .calc .item-text {
    font-size: 28px;
    font-weight: bold;
    color: @base0D;
  }

  .calc .item-subtext {
    font-size: 13px;
    color: @base03;
  }

  .symbols .item-image {
    font-size: 24px;
  }

  .todo.done .item-text-box {
    opacity: 0.25;
  }

  .todo.urgent {
    font-size: 24px;
  }

  .todo.active {
    font-weight: bold;
  }

  .bluetooth.disconnected {
    color: @base03;
  }

  .providerlist .item-subtext {
    font-size: unset;
    color: @base03;
  }

  .keybinds {
    padding: 0;
    margin: 0;
    min-height: 0;
    opacity: 0;
  }

  .global-keybinds,
  .item-keybinds,
  .keybind,
  .keybind-button,
  .keybind-bind,
  .keybind-label {
    min-height: 0;
    padding: 0;
    margin: 0;
  }

  :not(.calc).current {
    font-style: italic;
  }

  .error {
    padding: 10px 14px;
    background: @base08;
    color: @base00;
  }

  .wallpaper-item {
    padding: 8px;
    border-radius: 0;
  }

  .wallpaper-preview {
    min-height: 120px;
    min-width: 180px;
    border: 1px solid @base02;
  }

  .wallpaper-label {
    font-size: 12px;
    color: @base03;
    padding-top: 6px;
  }

  child:selected .wallpaper-item {
    background: @base02;
  }

  child:selected .wallpaper-label {
    color: @base05;
  }

  .preview-content.archlinuxpkgs,
  .preview-content.dnfpackages {
    font-family: monospace;
  }
''
