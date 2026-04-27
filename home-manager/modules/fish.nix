{pkgs, ...}: {
  programs.fish = {
    enable = true;
    preferAbbrs = true;
    binds = {
      "alt-s" = {
        erase = true;
        operate = "preset";
        mode = "insert";
      };
    };
    functions = {
      mkcd = {
        body = ''
          mkdir -p $argv[1]
          cd $argv[1]
        '';
        description = "Create a directory and cd into it";
        argumentNames = "dir";
      };

      # ── project switcher ───────────────────────────────────────────────────
      proj = {
        description = "Fuzzy switch to a project and open neovim";
        body = ''
          set roots $HOME/projects $HOME/oss
          set target (fd --type d --max-depth 1 . $roots \
              | fzf --prompt="project  " --height=50% --layout=reverse --border \
                    --preview 'ls -la {}' --preview-window=right:40%)
          or return
          cd $target
          and nvim .
        '';
      };

      # ── live grep → nvim ───────────────────────────────────────────────────
      # fzf.fish has no rg integration; Ctrl+Alt+S is git status only.
      vg = {
        description = "Grep project and open match in nvim";
        body = ''
          set result (rg --color=always --line-number --no-heading --smart-case $argv \
              | fzf --ansi --height=60% --layout=reverse --border \
                    --delimiter=: \
                    --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                    --preview-window=right:55%:+{2}-5)
          if test -n "$result"
              set file (string split ":" $result)[1]
              set line (string split ":" $result)[2]
              nvim +$line $file
          end
        '';
      };

      vgw = {
        description = "Grep exact word in project and open in nvim";
        body = ''
          vg --word-regexp $argv
        '';
      };

      # ── zoxide jump + nvim ─────────────────────────────────────────────────
      # fzf.fish has no zoxide integration.
      vz = {
        description = "Zoxide jump to a directory and open nvim";
        body = ''
          set result (cdi)
          if test -n "$result"
              cd $result
              nvim .
          end
        '';
      };

      # ── search lines in a file → nvim ──────────────────────────────────────
      vl = {
        description = "Search lines in a file and jump to match in nvim";
        body = ''
          if test -z "$argv[1]"
              echo "usage: vl <file>"
              return 1
          end
          set result (rg --line-number --no-heading --color=always "" $argv[1] \
              | fzf --ansi --height=60% --layout=reverse --border \
                    --delimiter=: \
                    --preview "bat --style=numbers --color=always --highlight-line {1} $argv[1]" \
                    --preview-window=right:55%:+{1}-5)
          if test -n "$result"
              set line (string split ":" $result)[1]
              nvim +$line $argv[1]
          end
        '';
      };

      # ── todo grep ──────────────────────────────────────────────────────────
      vtodo = {
        description = "List TODO/FIXME/NOTE/HACK comments and open in nvim";
        body = ''
          set result (rg --color=always --line-number --no-heading \
              'TODO|FIXME|HACK|NOTE|BUG|WARN' \
              | fzf --ansi --height=60% --layout=reverse --border \
                    --delimiter=: \
                    --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                    --preview-window=right:55%:+{2}-5)
          if test -n "$result"
              set file (string split ":" $result)[1]
              set line (string split ":" $result)[2]
              nvim +$line $file
          end
        '';
      };

      # ── tmux helpers ───────────────────────────────────────────────────────
      tmux-switch = {
        description = "Fuzzy switch tmux window";
        body = ''
          tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" | \
            fzf-tmux -p 60%,40% --prompt="switch  " --border rounded | \
            awk '{print $1}' | \
            xargs -I{} tmux switch-client -t {}
        '';
      };

      tmux-kill = {
        description = "Fuzzy kill tmux pane/window/session";
        body = ''
          set target (echo -e "pane\nwindow\nsession" | fzf-tmux -p 40%,30% --prompt="kill  " --border rounded)
          switch $target
            case pane
              tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
                fzf-tmux -p 60%,40% --prompt="kill pane  " | \
                awk '{print $1}' | \
                xargs -I{} tmux kill-pane -t {}
            case window
              tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" | \
                fzf-tmux -p 60%,40% --prompt="kill window  " | \
                awk '{print $1}' | \
                xargs -I{} tmux kill-window -t {}
            case session
              tmux list-sessions -F "#{session_name}" | \
                fzf-tmux -p 50%,35% --prompt="kill session  " | \
                xargs -I{} tmux kill-session -t {}
          end
        '';
      };
    };

    interactiveShellInit = ''
      set -g fish_greeting
      fish_vi_key_bindings

      # fzf.fish — show hidden files in Alt+F, matching fd flags used elsewhere
      set fzf_fd_opts --hidden --follow --exclude .git

      # use eza for directory previews in Alt+F
      set fzf_preview_dir_cmd eza --all --color=always

      # fzf.fish key bindings — strip Ctrl, use Alt+key only
      fzf_configure_bindings \
        --directory=\ef \
        --git_log=\el \
        --git_status=\eg \
        --history=\er \
        --processes=\ep \
        --variables=\ev
    '';

    loginShellInit = ''
      if uwsm check may-start > /dev/null; and uwsm select
          uwsm start default | systemd-cat -t uwsm_start
      end
    '';

    plugins = [
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
    ];
    shellAbbrs = {
      # ── system ──────────────────────────────────────────────────────────────
      ta = "tmux attach";
      ost = "nh os test";
      osw = "nh os switch";
      hms = "nh home switch";
      hmu = "nh home switch --update";
      osu = "nh os switch --update";
      nd = "nix develop -c $SHELL";
      ndi = "nix develop --impure -c $SHELL";
      pkgs = "nvim ~/flake/home-manager/home-packages.nix";
      # ── git ─────────────────────────────────────────────────────────────────
      gs = "git status";
      gc = "git checkout";
      # ── templates ───────────────────────────────────────────────────────────
      nt = "nix flake init --refresh --template github:Marcus441/nix-templates/main#";
      nf = "nix flake init --template templates#";
      # ── nvim quick open ─────────────────────────────────────────────────────
      ne = "nvim ."; # open oil in cwd
      nn = "nvim (mktemp)"; # scratch file
    };

    shellAliases = {
      gg = "git-graph --style round";
    };
  };
}
