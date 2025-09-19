{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    shellAliases = let
      home-managerDir = "~/flake/home-manager";
    in {
      sw = "nh os switch";
      upd = "nh os switch --update";
      hms = "nh home switch";
      nd = "nix develop -c zsh";

      pkgs = "nvim ${home-managerDir}/home-packages.nix";

      r = "ranger";
      v = "nvim";
      se = "sudoedit";
      fetch = "fastfetch && echo";

      lsa = "ls -lah";
      vim = "nvim";
      c = "clear";
      t = "tmux";
      ta = "tmux attach";
      tn = "tmux new-session";
      tns = "tmux new-session -s";

      # GIT
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      gpl = "git pull";
      gst = "git stash";
      gsp = "git stash; git pull";
      gcheck = "git checkout";
      gcredential = "git config credential.helper store";
      ".." = "cd ..";
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      # Start UWSM
      if uwsm check may-start > /dev/null && uwsm select; then
        exec systemd-cat -t uwsm_start uwsm start default
      fi

      autoload -Uz compinit && compinit

      # Completion styling
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "$LS_COLORS"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

      eval "$(zoxide init --cmd cd zsh)"

      # Shell function for initializing a project template
      nt() {
        if [ -z "$1" ]; then
          echo "Usage: nt <template-name>"
          return 1
        fi
        nix flake init --template "github:Marcus441/nix-templates/main#$1"
      }

    '';
  };
}
