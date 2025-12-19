{
  pkgs,
  config,
  ...
}: let
  # Define colors
  thm_bg = "#272626";
  thm_fg = "#c5c9c5";
  thm_cyan = "#879FAB";
  thm_black = "#0d0c0c";
  thm_gray = "#2d4f67";
  thm_magenta = "#a292a3";
  thm_red = "#BE716B";
  thm_blue = "#8ba4b0";
  thm_darkBlue = "#242434";
  thm_black4 = "#181616";
in {
  programs.tmux = {
    enable = true;
    prefix = "C-b";
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
      }
    ];
    extraConfig = ''
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # Status bar settings
      set -g status "on"
      set -g status-position top
      set -g status-bg "${thm_bg}"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      # Messages
      set -g message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
      set -g message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

      # Panes
      set -g pane-border-style "fg=${thm_gray}"
      set -g pane-active-border-style "fg=${thm_blue}"

      # Windows
      set -g window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
      set -g window-status-separator ""
      set -g window-status-style "fg=${thm_fg},bg=${thm_bg},none"

      # Statusline - current window (Active)
      set -g window-status-current-format "\
      #[fg=${thm_black},bg=${thm_cyan}] #I \
      #[fg=${thm_cyan},bg=${thm_darkBlue}]\
      #[fg=${thm_blue},bg=${thm_darkBlue}] #{b:pane_current_path} \
      #[fg=${thm_darkBlue},bg=${thm_bg}]"

      # Statusline - other windows (Inactive)
      set -g window-status-format "\
      #[fg=${thm_fg},bg=${thm_bg}] #I #[fg=${thm_fg}]"

      # Statusline - right side
      set -g status-right "\
      #{?client_prefix,#[fg=${thm_black4}],#[fg=${thm_darkBlue}]}#[bg=${thm_bg},nobold,nounderscore,noitalics]\
      #{?client_prefix,#[fg=${thm_red} bg=${thm_black4}],#[fg=${thm_blue} bg=${thm_darkBlue}]}  #W \
      #{?client_prefix,#[fg=${thm_red} bg=${thm_black4}],#[fg=${thm_cyan} bg=${thm_darkBlue}]}\
      #{?client_prefix,#[bg=${thm_red}],#[bg=${thm_cyan}]}#[fg=${thm_black}] \
      #{?client_prefix,#[bg=${thm_red}],#[bg=${thm_cyan}]}#[fg=${thm_black}] #S "



      # Statusline - left side (empty)
      set -g status-left ""

      # Modes
      set -g clock-mode-colour "${thm_blue}"
      set -g mode-style "fg=${thm_blue} bg=${thm_black4} bold"

      set -g renumber-windows on
      set-option -g detach-on-destroy off

      bind-key r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v run-shell 'tmux send-keys -X rectangle-toggle; tmux send-keys -X begin-selection'
      bind-key -T copy-mode-vi y \
        send-keys -X copy-selection-and-cancel \;\
        run-shell -b "tmux save-buffer - | wl-copy --no-newline >/dev/null 2>&1 || true"

      bind-key -r o command-prompt -p "Name of new session:" "new-session -s '%%'"

      bind -n M-g display-popup -E -w 90% -h 90% -T "LazyGit" "lazygit"
      bind -n M-p display-popup -E -w 90% -h 90% -T "gh-dash" "gh-dash"
      bind -n M-d detach

      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      bind -n M-v split-window -v -c "#{pane_current_path}"
      bind -n M-s split-window -h -c "#{pane_current_path}"

      bind -n M-T new-window -c "$HOME" "nvim --cmd todolist.md"
      bind -n M-Enter new-window
      bind -n M-c kill-pane
      bind -n M-x kill-window
      bind -n M-X kill-session

      bind -n M-a run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
      )\""


      # tmuxplugin-continuum
      # ---------------------
      set-option -g @continuum-restore 'on'
      set-option -g @continuum-save-interval '5' # minutes
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
