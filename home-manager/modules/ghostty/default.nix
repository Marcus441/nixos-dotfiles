{user, ...}: {
  programs.ghostty = {
    enable = true;
    systemd.enable = true;
    settings = {
      # Window
      window-padding-x = 10;
      window-padding-y = 10;
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      working-directory = "home";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "10m";
      gtk-toolbar-style = "flat";
      resize-overlay = "never";

      # Font
      font-size = 14;

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;
      # custom-shader = "/home/${user}/dotfiles/flake/home-manager/modules/ghostty/cursor_smear.glsl";

      # Splits & Tabs
      unfocused-split-opacity = 0.8;
      split-inherit-working-directory = true;
      tab-inherit-working-directory = true;

      # Mouse
      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = 0.95;
      focus-follows-mouse = false;
      copy-on-select = true;

      # Shell & Input
      shell-integration-features = "no-cursor,ssh-env,ssh-terminfo,sudo,title";
      async-backend = "epoll";

      # Misc
      scrollback-limit = 50000;
      confirm-close-surface = false;
      app-notifications = "no-clipboard-copy";

      keybind = [
        # Create splits
        "alt+left=new_split:left"
        "alt+down=new_split:down"
        "alt+up=new_split:up"
        "alt+right=new_split:right"

        # Split navigation
        "ctrl+left=goto_split:left"
        "ctrl+down=goto_split:down"
        "ctrl+up=goto_split:up"
        "ctrl+right=goto_split:right"

        "ctrl+shift+left=resize_split:left,10"
        "ctrl+shift+down=resize_split:down,10"
        "ctrl+shift+up=resize_split:up,10"
        "ctrl+shift+right=resize_split:right,10"

        # Tab Navigation
        "ctrl+1=goto_tab:1"
        "ctrl+2=goto_tab:2"
        "ctrl+3=goto_tab:3"
        "ctrl+4=goto_tab:4"
        "ctrl+5=goto_tab:5"
        "ctrl+6=goto_tab:6"
        "ctrl+7=goto_tab:7"
        "ctrl+8=goto_tab:8"
        "ctrl+9=goto_tab:9"
        "ctrl+0=goto_tab:10"

        # Standard Tab controls
        "ctrl+shift+t=new_tab"
        "ctrl+w=close_tab:this"
        "ctrl+shift+o=toggle_tab_overview"
      ];
    };
  };
}
