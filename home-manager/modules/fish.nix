{
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

      vg = {
        description = "Grep project and open match in nvim";
        body = ''
          if test -n "$argv[1]"
              set pat $argv
          else
              set pat "."
          end
          set result (rg --color=always --line-number --no-heading --smart-case $pat \
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
    };

    interactiveShellInit = ''
      set -g fish_greeting
      fish_vi_key_bindings

    '';

    loginShellInit = ''
      if uwsm check may-start > /dev/null; and uwsm select
          uwsm start default | systemd-cat -t uwsm_start
      end
    '';

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
      ne = "nvim .";
      nn = "nvim (mktemp)";
    };

    shellAliases = {
      gg = "git-graph --style round";
    };
  };
}
