_: {
  flake.modules.homeManager.apps = [
    (
      {
        config,
        lib,
        ...
      }: let
        c = lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors16;
        thm_bg = "#${c.base00}";
        thm_surface = "#${c.base01}";
        thm_gray = "#${c.base03}";
        thm_dim = "#${c.base04}";
        thm_fg = "#${c.base05}";
        thm_red = "#${c.base08}";
        thm_blue = "#${c.base0D}";
      in {
        programs.tmux = {
          enable = true;
          prefix = "C-a";
          baseIndex = 1;
          mouse = true;
          escapeTime = 0;
          keyMode = "vi";
          terminal = "xterm-256color";
          extraConfig = ''
            # General
            set -g allow-passthrough on
            set -ga update-environment TERM
            set -ga update-environment TERM_PROGRAM
            set -ag terminal-overrides ",*:RGB"
            set -g renumber-windows on
            set -g history-limit 50000
            set -g focus-events on
            set -g set-clipboard on
            set -g detach-on-destroy off

            # Reload config
            bind q source-file ~/.config/tmux/tmux.conf \; display "reloaded"

            # Vi copy mode
            bind -T copy-mode-vi v send -X begin-selection
            bind -T copy-mode-vi V send -X select-line
            bind -T copy-mode-vi C-v run-shell 'tmux send-keys -X rectangle-toggle; tmux send-keys -X begin-selection'
            bind -T copy-mode-vi y \
              send-keys -X copy-selection-and-cancel \;\
              run-shell -b "tmux save-buffer - | wl-copy --no-newline >/dev/null 2>&1 || true"
            bind -T copy-mode-vi MouseDragEnd1Pane \
              send-keys -X copy-selection-and-cancel \;\
              run-shell -b "tmux save-buffer - | wl-copy --primary --no-newline >/dev/null 2>&1 || true" \;\
              run-shell -b "tmux save-buffer - | wl-copy --no-newline >/dev/null 2>&1 || true"

            # Pane controls
            bind s split-window -v -c "#{pane_current_path}"
            bind v split-window -h -c "#{pane_current_path}"
            bind x kill-pane

            # load-bearing: docs/decisions/terminal.md#tmux-pane-is-vim
            bind -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
            bind -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
            bind -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
            bind -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'
            bind C-l send-keys C-l

            bind -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
            bind -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
            bind -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
            bind -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

            bind -T copy-mode-vi C-h select-pane -L
            bind -T copy-mode-vi C-j select-pane -D
            bind -T copy-mode-vi C-k select-pane -U
            bind -T copy-mode-vi C-l select-pane -R

            # Window controls
            bind r command-prompt -I "#W" "rename-window -- '%%'"
            bind c new-window -c "#{pane_current_path}"
            bind k kill-window
            bind -n M-Enter new-window -c "#{pane_current_path}"
            bind -n M-1 select-window -t 1
            bind -n M-2 select-window -t 2
            bind -n M-3 select-window -t 3
            bind -n M-4 select-window -t 4
            bind -n M-5 select-window -t 5
            bind -n M-6 select-window -t 6
            bind -n M-7 select-window -t 7
            bind -n M-8 select-window -t 8
            bind -n M-9 select-window -t 9
            bind -n M-Left swap-window -t -1 \; select-window -t -1
            bind -n M-Right swap-window -t +1 \; select-window -t +1

            # Session controls
            bind -n M-s choose-tree -Zs
            bind R command-prompt -I "#S" "rename-session -- '%%'"
            bind C new-session -c "#{pane_current_path}"
            bind K kill-session
            bind -n M-Up switch-client -p
            bind -n M-Down switch-client -n

            # Status bar
            set -g status-position top
            set -g status-interval 5
            set -g status-left-length 30
            set -g status-right-length 50
            set -g window-status-separator ""
            set -gw automatic-rename on
            set -gw automatic-rename-format '#{b:pane_current_path}'

            # Theme
            set -g status-style "bg=default,fg=default"
            set -g status-left "#[fg=${thm_bg},bg=${thm_blue},bold] #S #[bg=default] "
            set -g status-right "#[fg=${thm_blue}]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#[fg=${thm_gray}]#h "
            set -g window-status-format "#[fg=${thm_gray}] #I:#W "
            set -g window-status-current-format "#[fg=${thm_blue},bold] #I:#W "
            set -g pane-border-style "fg=${thm_gray}"
            set -g pane-active-border-style "fg=${thm_blue}"
            set -g message-style "bg=default,fg=${thm_blue}"
            set -g message-command-style "bg=default,fg=${thm_blue}"
            set -g mode-style "bg=${thm_blue},fg=${thm_bg}"
            setw -g clock-mode-colour "${thm_blue}"

            # States the inline status line cannot reach: pane numbers, bell.
            set -g display-panes-active-colour "${thm_dim}"
            set -g display-panes-colour "${thm_surface}"
            setw -g window-status-bell-style "fg=${thm_bg},bg=${thm_red}"
            setw -g window-status-activity-style "fg=${thm_fg},bg=${thm_bg}"
          '';
        };
      }
    )
  ];
}
