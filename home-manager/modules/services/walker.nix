{
  services.walker = {
    enable = true;

    systemd.enable = true;

    settings = {
      close_when_open = true;
      force_keyboard_focus = true;
      timeout = 60;

      keys = {
        ai = {
          run_last_response = ["ctrl e"];
        };
      };

      list = {
        max_entries = 200;
        cycle = true;
      };

      search = {
        placeholder = " Search...";
      };

      builtins = {
        applications = {
          name = "Apps";
          launch_prefix = "uwsm app -- ";
          placeholder = " Search...";
          prioritize_new = false;
          context_aware = false;
          show_sub_when_single = false;
          history = false;
          hidden = false;

          actions = {
            enabled = false;
            hide_category = true;
          };
        };

        calc = {
          name = "Calculator";
          min_chars = 3;
          prefix = "=";
        };

        emojis = {
          name = "Emojis";
          placeholder = " Search...";
        };

        clipboard = {
          placeholder = " Search cliphist...";
        };

        symbols = {
          after_copy = "";
          hidden = true;
        };

        finder = {
          name = "Finder";
          use_fd = true;
          cmd_alt = "xdg-open $(dirname ~/%RESULT%)";
          icon = "file";
          preview_images = true;
          hidden = false;
          prefix = "/";
        };
      };
    };

    theme = {
      name = "custom";
      layout = {
        "ui.window.box.width" = 664;
        "ui.window.box.min_width" = 664;
        "ui.window.box.max_width" = 664;
        "ui.window.box.height" = 396;
        "ui.window.box.min_height" = 396;
        "ui.window.box.max_height" = 396;

        # Prevents window shrinking when list is empty
        "ui.window.box.scroll.list.height" = 300;
        "ui.window.box.scroll.list.min_height" = 300;
        "ui.window.box.scroll.list.max_height" = 300;

        "ui.window.box.scroll.list.item.icon.pixel_size" = 40;
      };

      style = ''
        @define-color selected-text #c8c093;
        @define-color text #c5c9c5;
        @define-color base #181616;
        @define-color border #8ba4b0;
        @define-color foreground #c5c9c5;
        @define-color background #181616;

        #window,
        #box,
        #search,
        #password,
        #input,
        #prompt,
        #clear,
        #typeahead,
        #list,
        child,
        scrollbar,
        slider,
        #item,
        #text,
        #label,
        #sub,
        #activationlabel {
          all: unset;
        }

        * {
          font-family: "Noto Sans", "Font Awesome 7 Free Solid";
          font-size: 18px;
        }

        /* Window */
        #window {
          background: transparent;
          color: @text;
        }

        /* Main box container */
        #box {
          background: alpha(@base, 0.95);
          padding: 20px;
          border: 2px solid @border;
          border-radius: 0px;
        }

        /* Search container */
        #search {
          background: @base;
          padding: 10px;
          margin-bottom: 0;
        }

        /* Hide prompt icon */
        #prompt {
          opacity: 0;
          min-width: 0;
          margin: 0;
        }

        /* Hide clear button */
        #clear {
          opacity: 0;
          min-width: 0;
        }

        /* Input field */
        #input {
          background: none;
          color: @text;
          padding: 0;
        }

        #input placeholder {
          opacity: 0.5;
          color: @text;
        }

        /* Hide typeahead */
        #typeahead {
          opacity: 0;
        }

        /* List */
        #list {
          background: transparent;
        }

        /* List items */
        child {
          padding: 0px 12px;
          background: transparent;
          border-radius: 0;
        }

        child:selected,
        child:hover {
          background: transparent;
        }

        /* Item layout */
        #item {
          padding: 0;
        }

        #item.active {
          font-style: italic;
        }

        /* Icon */
        #icon {
          margin-right: 10px;
          -gtk-icon-transform: scale(0.7);
        }

        /* Text */
        #text {
          color: @text;
          padding: 14px 0;
        }

        #label {
          font-weight: normal;
        }

        /* Selected state */
        child:selected #text,
        child:selected #label,
        child:hover #text,
        child:hover #label {
          color: @selected-text;
        }

        /* Hide sub text */
        #sub {
          opacity: 0;
          font-size: 0;
          min-height: 0;
        }

        /* Hide activation label */
        #activationlabel {
          opacity: 0;
          min-width: 0;
        }

        /* Scrollbar styling */
        scrollbar {
          opacity: 0;
        }

        /* Hide spinner */
        #spinner {
          opacity: 0;
        }

        /* Hide AI elements */
        #aiScroll,
        #aiList,
        .aiItem {
          opacity: 0;
          min-height: 0;
        }

        /* Bar entry (switcher) */
        #bar {
          opacity: 0;
          min-height: 0;
        }

        .barentry {
          opacity: 0;
        }
      '';
    };
  };
}
