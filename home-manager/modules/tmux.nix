{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "xterm-ghostty";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''

          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-strategy-vim 'session'

          set -g @resurrect-capture-pane-contents 'on'

          # Thanks to
          # https://discourse.nixos.org/t/how-to-get-tmux-resurrect-to-restore-neovim-sessions/30819/10
          set -g @resurrect-dir "$HOME/.tmux/resurrect"
          set -g @resurrect-hook-post-save-all "sed -i -E 's|:/nix/store/[^ ]+/bin/nvim.*|:nvim|g; s|/home/[^/]+/.nix-profile/bin/||g; s|--cmd.*||g' $HOME/.tmux/resurrect/last"
          set -g @resurrect-processes '"~nvim"'
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set-option -g @continuum-restore 'on'
          set-option -g @continuum-save-interval '10' # minutes
        '';
      }
    ];
    extraConfig = ''
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      set -g status-position top

      set -g status-style bg=default
      set -g status-left ""
      set -g status-right "#S"

      set -g window-status-format "● #W "
      set -g window-status-current-format "● #W "
      set -g window-status-style "bg=default"
      set -g window-status-current-style "#{?window_zoomed_flag,fg=yellow,fg=magenta,nobold}"

      set -g renumber-windows on

      set-option -g detach-on-destroy off

      bind-key r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v run-shell 'tmux send-keys -X rectangle-toggle; tmux send-keys -X begin-selection'
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel \; run-shell "tmux save-buffer - | wl-copy --no-newline"

      bind-key -r o command-prompt -p "Name of new session:" "new-session -s '%%'"

      bind -n M-a choose-tree -s
      bind -n M-D detach

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-Left  resize-pane -L 5
      bind -n M-Right resize-pane -R 5
      bind -n M-Up    resize-pane -U 3
      bind -n M-Down  resize-pane -D 3

      bind -n M-S-Left  resize-pane -L 15
      bind -n M-S-Right resize-pane -R 15
      bind -n M-S-Up    resize-pane -U 9
      bind -n M-S-Down  resize-pane -D 9

      bind -n M-s split-window -v -c "#{pane_current_path}"
      bind -n M-v split-window -h -c "#{pane_current_path}"

      bind -n M-T new-window -c "$HOME" "nvim --cmd 'autocmd VimEnter * ++once lua vim.defer_fn(function() require(\"telescope.builtin\").find_files() end, 100)' todolist.md"
      bind -n M-Enter new-window
      bind -n M-d kill-pane
      bind -n M-x kill-window
      bind -n M-X kill-session


      # tmuxplugin-continuum
      # ---------------------
      set-option -g @continuum-restore 'on'
      set-option -g @continuum-save-interval '5' # minutes
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
