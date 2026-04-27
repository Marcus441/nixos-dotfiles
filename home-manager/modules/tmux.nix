{
  pkgs,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  thm_bg = "#${c.base00}";
  thm_gray = "#${c.base03}";
  thm_blue = "#${c.base0D}";
in {
  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "xterm-256color";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-dir "$HOME/.tmux/resurrect"
          set -g @resurrect-hook-post-save-all "sed -i -E 's|:/nix/store/[^ ]+/bin/nvim.*|:nvim|g; s|/home/[^/]+/.nix-profile/bin/||g; s|--cmd.*||g' $HOME/.tmux/resurrect/last"
          set -g @resurrect-processes '"~nvim"'
        '';
      }
      {plugin = pkgs.tmuxPlugins.vim-tmux-navigator;}
      {plugin = pkgs.tmuxPlugins.continuum;}
    ];
    extraConfig = ''
      # Prefix
      set -g prefix2 C-b
      bind C-Space send-prefix

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
      bind q source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

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
      bind h split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind x kill-pane
      bind -n M-v split-window -v -c "#{pane_current_path}"
      bind -n M-h split-window -h -c "#{pane_current_path}"
      bind -n M-c kill-pane
      bind -n C-M-Left select-pane -L
      bind -n C-M-Right select-pane -R
      bind -n C-M-Up select-pane -U
      bind -n C-M-Down select-pane -D
      bind -n C-M-S-Left resize-pane -L 5
      bind -n C-M-S-Down resize-pane -D 5
      bind -n C-M-S-Up resize-pane -U 5
      bind -n C-M-S-Right resize-pane -R 5

      # Window navigation
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
      bind R command-prompt -I "#S" "rename-session -- '%%'"
      bind C new-session -c "#{pane_current_path}"
      bind K kill-session
      bind P switch-client -p
      bind N switch-client -n
      bind -n M-Up switch-client -p
      bind -n M-Down switch-client -n
      bind -n M-s run-shell "fish -c tmux-switch"
      bind -n M-k run-shell "fish -c tmux-kill"

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

      # Continuum
      set-option -g @continuum-restore 'on'
      set-option -g @continuum-save-interval '5'
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
