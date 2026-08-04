{
  # Bash translation of the retired fish config (step 1.2 of REFACTOR.md).
  # Plain aliases stand in for fish abbreviations. Lives in the maximal
  # profile, not core, because it references maximal-only tools (tmux,
  # batman, git-graph) and the uwsm session hook.
  programs.bash = {
    shellAliases = {
      # ── system ──────────────────────────────────────────────────────────────
      ta = "tmux attach";
      ost = "nh os test";
      osw = "nh os switch";
      hms = "nh home switch";
      hmu = "nh home switch --update";
      osu = "nh os switch --update";
      nd = "nix develop -c $SHELL";
      ndi = "nix develop --impure -c $SHELL";
      pkgs = "nvim ~/flake/home-manager/core/packages.nix";
      # ── git ─────────────────────────────────────────────────────────────────
      gs = "git status";
      gc = "git checkout";
      gg = "git-graph --style round";
      # ── templates ───────────────────────────────────────────────────────────
      nt = "nix flake init --refresh --template github:Marcus441/nix-templates/main#";
      nf = "nix flake init --template templates#";
      # ── nvim quick open ─────────────────────────────────────────────────────
      ne = "nvim .";
      nn = "nvim \"$(mktemp)\"";
      # ── misc ────────────────────────────────────────────────────────────────
      man = "batman";
    };

    # Session autostart for TTY logins, moved from fish.loginShellInit. ly
    # normally starts the uwsm-managed Hyprland session directly; this covers
    # a plain console login.
    profileExtra = ''
      if uwsm check may-start > /dev/null && uwsm select; then
        uwsm start default | systemd-cat -t uwsm_start
      fi
    '';

    initExtra = ''
      # Create a directory and cd into it
      mkcd() { mkdir -p "$1" && cd "$1"; }

      # Fuzzy switch to a project and open neovim
      proj() {
        local target
        target=$(fd --type d --max-depth 1 . "$HOME/Projects" "$HOME/oss" \
          | fzf --prompt="project  " --height=50% --layout=reverse --border \
                --preview 'ls -la {}' --preview-window=right:40%) || return
        cd "$target" && nvim .
      }

      # Grep project and open match in nvim
      vg() {
        local pat=''${*:-.} result file line
        result=$(rg --color=always --line-number --no-heading --smart-case "$pat" \
          | fzf --ansi --height=60% --layout=reverse --border \
                --delimiter=: \
                --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                --preview-window=right:55%:+{2}-5)
        if [[ -n $result ]]; then
          file=''${result%%:*}
          line=$(cut -d: -f2 <<<"$result")
          nvim +"$line" "$file"
        fi
      }

      # Search lines in a file and jump to match in nvim
      vl() {
        if [[ -z $1 ]]; then
          echo "usage: vl <file>"
          return 1
        fi
        local result
        result=$(rg --line-number --no-heading --color=always "" "$1" \
          | fzf --ansi --height=60% --layout=reverse --border \
                --delimiter=: \
                --preview "bat --style=numbers --color=always --highlight-line {1} $1" \
                --preview-window=right:55%:+{1}-5)
        [[ -n $result ]] && nvim +"''${result%%:*}" "$1"
      }

      # List TODO/FIXME/NOTE/HACK comments and open in nvim
      vtodo() {
        local result file line
        result=$(rg --color=always --line-number --no-heading \
            'TODO|FIXME|HACK|NOTE|BUG|WARN' \
          | fzf --ansi --height=60% --layout=reverse --border \
                --delimiter=: \
                --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                --preview-window=right:55%:+{2}-5)
        if [[ -n $result ]]; then
          file=''${result%%:*}
          line=$(cut -d: -f2 <<<"$result")
          nvim +"$line" "$file"
        fi
      }
    '';
  };
}
