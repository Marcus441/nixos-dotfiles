{inputs, ...}: {
  imports = [inputs.walker.homeManagerModules.default];
  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      # === General ===
      theme = "custom";
      force_keyboard_focus = false;
      close_when_open = true;
      click_to_close = true;
      selection_wrap = false;
      global_argument_delimiter = "#";
      exact_search_prefix = "'";
      disable_mouse = false;
      debug = false;

      # === Shell anchors ===
      shell = {
        anchor_top = true;
        anchor_bottom = true;
        anchor_left = true;
        anchor_right = true;
      };

      # === Placeholders ===
      placeholders = {
        default = {
          input = " Search";
          list = "No Results";
        };
      };

      # === Keybinds ===
      keybinds = {
        close = ["Escape"];
        next = ["alt j"];
        previous = ["alt k"];
        toggle_exact = ["ctrl e"];
        resume_last_query = ["ctrl r"];
        quick_activate = [];
      };

      # === Providers ===
      providers = {
        default = [
          "desktopapplications"
          "calc"
          "runner"
          "menus"
          "websearch"
        ];
        empty = ["desktopapplications"];
        max_results = 50;

        sets = {};
        max_results_provider = {};

        prefixes = [
          {
            prefix = ";";
            provider = "providerlist";
          }
          {
            prefix = "/";
            provider = "files";
          }
          {
            prefix = ".";
            provider = "symbols";
          }
          {
            prefix = "!";
            provider = "todo";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = ":";
            provider = "clipboard";
          }
        ];

        clipboard = {
          time_format = "%d.%m. - %H:%M";
        };

        actions = {
          dmenu = [
            {
              action = "select";
              default = true;
              bind = "Return";
            }
          ];
          providerlist = [
            {
              action = "activate";
              default = true;
              bind = "Return";
              after = "ClearReload";
            }
          ];
          bluetooth = [
            {
              action = "find";
              global = true;
              bind = "ctrl f";
              after = "AsyncClearReload";
            }
            {
              action = "trust";
              bind = "ctrl t";
              after = "AsyncReload";
            }
            {
              action = "untrust";
              bind = "ctrl t";
              after = "AsyncReload";
            }
            {
              action = "pair";
              bind = "Return";
              after = "AsyncReload";
            }
            {
              action = "remove";
              bind = "ctrl d";
              after = "AsyncReload";
            }
            {
              action = "connect";
              bind = "Return";
              after = "AsyncReload";
            }
            {
              action = "disconnect";
              bind = "Return";
              after = "AsyncReload";
            }
          ];
          desktopapplications = [
            {
              action = "start";
              default = true;
              bind = "Return";
            }
            {
              action = "start";
              label = "open+next";
              bind = "shift Return";
              after = "KeepOpen";
            }
            {
              action = "erase_history";
              label = "clear hist";
              bind = "ctrl h";
              after = "AsyncReload";
            }
            {
              action = "pin";
              bind = "ctrl p";
              after = "AsyncReload";
            }
            {
              action = "unpin";
              bind = "ctrl p";
              after = "AsyncReload";
            }
            {
              action = "pinup";
              bind = "ctrl n";
              after = "AsyncReload";
            }
            {
              action = "pindown";
              bind = "ctrl m";
              after = "AsyncReload";
            }
          ];
          files = [
            {
              action = "open";
              default = true;
              bind = "Return";
            }
            {
              action = "opendir";
              label = "open dir";
              bind = "ctrl Return";
            }
            {
              action = "copypath";
              label = "copy path";
              bind = "ctrl shift c";
            }
            {
              action = "copyfile";
              label = "copy file";
              bind = "ctrl c";
            }
          ];
          todo = [
            {
              action = "save";
              default = true;
              bind = "Return";
              after = "ClearReload";
            }
            {
              action = "delete";
              bind = "ctrl d";
              after = "ClearReload";
            }
            {
              action = "active";
              bind = "Return";
              after = "ClearReload";
            }
            {
              action = "inactive";
              bind = "Return";
              after = "ClearReload";
            }
            {
              action = "done";
              bind = "ctrl f";
              after = "ClearReload";
            }
            {
              action = "clear";
              bind = "ctrl x";
              after = "ClearReload";
              global = true;
            }
          ];
          calc = [
            {
              action = "copy";
              default = true;
              bind = "Return";
            }
            {
              action = "delete";
              bind = "ctrl d";
              after = "AsyncReload";
            }
            {
              action = "save";
              bind = "ctrl s";
              after = "AsyncClearReload";
            }
          ];
          websearch = [
            {
              action = "search";
              default = true;
              bind = "Return";
            }
            {
              action = "erase_history";
              label = "clear hist";
              bind = "ctrl h";
              after = "Reload";
            }
          ];
          runner = [
            {
              action = "run";
              default = true;
              bind = "Return";
            }
            {
              action = "runterminal";
              label = "run in terminal";
              bind = "shift Return";
            }
            {
              action = "erase_history";
              label = "clear hist";
              bind = "ctrl h";
              after = "Reload";
            }
          ];
          symbols = [
            {
              action = "run_cmd";
              label = "select";
              default = true;
              bind = "Return";
            }
            {
              action = "erase_history";
              label = "clear hist";
              bind = "ctrl h";
              after = "Reload";
            }
          ];
          unicode = [
            {
              action = "run_cmd";
              label = "select";
              default = true;
              bind = "Return";
            }
            {
              action = "erase_history";
              label = "clear hist";
              bind = "ctrl h";
              after = "Reload";
            }
          ];
          clipboard = [
            {
              action = "copy";
              default = true;
              bind = "Return";
            }
            {
              action = "remove";
              bind = "ctrl d";
              after = "ClearReload";
            }
            {
              action = "remove_all";
              global = true;
              label = "clear";
              bind = "ctrl shift d";
              after = "ClearReload";
            }
            {
              action = "toggle_images";
              global = true;
              label = "toggle images";
              bind = "ctrl i";
              after = "ClearReload";
            }
            {
              action = "edit";
              bind = "ctrl o";
            }
          ];
        };
      };
    };

    theme.name = "custom";
    theme.style = ''
      @define-color window_bg_color #181616;
      @define-color accent_bg_color #8BA4B0;
      @define-color theme_fg_color #C5C9C5;
      @define-color error_bg_color #C34043;
      @define-color error_fg_color #DCD7BA;

      * {
        all: unset;
        font-family: "Noto Sans", "Font Awesome 7 Free Solid";
        font-size: 18px;
      }

      .normal-icons {
        -gtk-icon-size: 16px;
      }

      .large-icons {
        -gtk-icon-size: 32px;
      }

      scrollbar {
        opacity: 0;
      }

      .box-wrapper {
        box-shadow:
          0 19px 38px rgba(0, 0, 0, 0.3),
          0 15px 12px rgba(0, 0, 0, 0.22);
        background: @window_bg_color;
        padding: 20px;
        border-radius: 0px;
        border: 2px solid @accent_bg_color;
      }

      .preview-box,
      .elephant-hint,
      .placeholder {
        color: @theme_fg_color;
      }

      .box {
      }

      .search-container {
        border-radius: 0px;
      }

      .input placeholder {
        opacity: 0.5;
      }

      .input {
        caret-color: @theme_fg_color;
        background: lighter(@window_bg_color);
        padding: 10px;
        color: @theme_fg_color;
      }

      .input:focus,
      .input:active {
      }

      .content-container {
      }

      .placeholder {
      }

      .scroll {
      }

      .list {
        color: @theme_fg_color;
      }

      child {
      }

      .item-box {
        border-radius: 0px;
        padding: 10px;
      }

      .item-quick-activation {
        margin-left: 10px;
        background: alpha(@accent_bg_color, 0.25);
        border-radius: 5px;
        padding: 10px;
      }

      child:hover .item-box,
      child:selected .item-box {
        background: alpha(@accent_bg_color, 0.25);
      }

      .item-text-box {
      }

      .item-text {
      }

      .item-subtext {
        font-size: 12px;
        opacity: 0.5;
      }

      .item-image,
      .item-image-text {
        margin-right: 10px;
      }

      .item-image-text {
        font-size: 28px;
      }

      .preview {
        border: 1px solid alpha(@accent_bg_color, 0.25);
        padding: 10px;
        border-radius: 0px;
        color: @theme_fg_color;
      }

      .calc .item-text {
        font-size: 24px;
      }

      .calc .item-subtext {
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
        opacity: 0.5;
      }

      .preview .large-icons {
        -gtk-icon-size: 64px;
      }

      .keybinds-wrapper {
        border-top: 1px solid lighter(@window_bg_color);
        font-size: 12px;
        opacity: 0.5;
        color: @theme_fg_color;
      }

      .keybinds {
      }

      .keybind {
      }

      .keybind-bind {
        /* color: lighter(@window_bg_color); */
        font-weight: bold;
      }

      .keybind-label {
      }

      .error {
        padding: 10px;
        background: @error_bg_color;
        color: @error_fg_color;
      }
    '';
  };
}
