{
  pkgs,
  inputs,
  ...
}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set-option -a terminal-features 'xterm-256color:RGB'
      set -as terminal-features ",alacritty*:RGB"
      bind -n M-r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind -n M-p previous-window
      bind -n M-n next-window

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-Left  select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up    select-pane -U
      bind -n M-Down  select-pane -D

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

      bind -n M-o new-window -c ~/para "nvim --cmd 'autocmd VimEnter * ++once lua vim.defer_fn(function() require(\"telescope.builtin\").find_files() end, 100)' todolist.md"
      bind -n M-f new-window -c ~/flake "nvim --cmd 'autocmd VimEnter * ++once lua vim.defer_fn(function() require(\"telescope.builtin\").find_files() end, 100)' flake.nix"
      bind -n M-Enter new-window
      bind -n M-c kill-pane
      bind -n M-x kill-window
      bind -n M-X kill-session

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"
      bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
      bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
      bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
      bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

      bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
      bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
      bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }
      bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
    '';
    plugins = [
      # {
      #   plugin = tmuxPlugins.resurrect;
      #   extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      # }
      # {
      #   plugin = tmuxPlugins.continuum;
      #   extraConfig = ''
      # set -g @continuum-restore 'on'
      # set -g @continuum-save-interval '60' # minutes
      #   '';
      # }
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
      }
      {
        plugin = inputs.minimal-tmux.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @minimal-tmux-bg "#A9B665"
          set -g @minimal-tmux-fg "#32302F"
        '';
      }
    ];
  };
}
