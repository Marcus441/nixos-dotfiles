{
  pkgs,
  config,
  ...
}: let
  c = config.lib.stylix.colors;
  thm_bg = "#${c.base00}";
  thm_fg = "#${c.base05}";
  thm_gray = "#${c.base03}";
  thm_red = "#${c.base08}";
  thm_blue = "#${c.base0D}";
  thm_black = "#${c.base01}";
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
        # theme
        plugin = pkgs.tmuxPlugins.tmux-nova;
        extraConfig = ''
          set -g status-position top
          set -g @nova-nerdfonts true
          set -g @nova-nerdfonts-left 
          set -g @nova-nerdfonts-right 

          set -g @nova-pane-active-border-style "${thm_blue}"
          set -g @nova-pane-border-style "${thm_gray}"
          set -g @nova-status-style-bg "${thm_bg}"
          set -g @nova-status-style-fg "${thm_fg}"
          set -g @nova-status-style-active-bg "${thm_blue}"
          set -g @nova-status-style-active-fg "${thm_bg}"
          set -g @nova-status-style-double-bg "${thm_bg}"

          set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

          set -g @nova-segment-mode "#{?client_prefix,,}"
          set -g @nova-segment-mode-colors "${thm_blue} ${thm_bg}"

          set -g @nova-segment-whoami "#(whoami)@#h"
          set -g @nova-segment-whoami-colors "${thm_blue} ${thm_bg}"

          set -g @nova-rows 0
          set -g @nova-segments-0-left "mode"
          set -g @nova-segments-0-right "whoami"
        '';
      }
      {
        plugin = pkgs.tmuxPlugins.continuum;
      }
    ];
    extraConfig = ''
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM


      set -g renumber-windows on
      set-option -g detach-on-destroy off

      bind-key r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v run-shell 'tmux send-keys -X rectangle-toggle; tmux send-keys -X begin-selection'
      bind-key -T copy-mode-vi y \
        send-keys -X copy-selection-and-cancel \;\
        run-shell -b "tmux save-buffer - | wl-copy --no-newline >/dev/null 2>&1 || true"
      bind-key -T copy-mode-vi MouseDragEnd1Pane \
        send-keys -X copy-selection-and-cancel \;\
        run-shell -b "tmux save-buffer - | wl-copy --primary --no-newline >/dev/null 2>&1 || true" \;\
        run-shell -b "tmux save-buffer - | wl-copy --no-newline >/dev/null 2>&1 || true"

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
      bind -n M-c split-window -h -c "#{pane_current_path}"

      bind -n M-s run-shell 'tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" | \
        fzf-tmux -p 60%,40% --prompt="switch  " --border rounded | \
        awk "{print \$1}" | \
        xargs -I{} tmux switch-client -t {}'

      bind -n M-k run-shell 'echo -e "pane\nwindow\nsession" | \
        fzf-tmux -p 40%,30% --prompt="kill  " --border rounded | \
        xargs -I{} sh -c \
          "case {} in \
            pane)    tmux list-panes -a -F \"#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}\" | fzf-tmux -p 60%,40% --prompt=\"kill pane  \" | awk \"{print \\\$1}\" | xargs tmux kill-pane -t ;; \
            window)  tmux list-windows -a -F \"#{session_name}:#{window_index} #{window_name}\" | fzf-tmux -p 60%,40% --prompt=\"kill window  \" | awk \"{print \\\$1}\" | xargs tmux kill-window -t ;; \
            session) tmux list-sessions -F \"#{session_name}\" | fzf-tmux -p 50%,35% --prompt=\"kill session  \" | xargs tmux kill-session -t ;; \
          esac"'

      bind -n M-T new-window -c "$HOME" "nvim --cmd todolist.md"
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
