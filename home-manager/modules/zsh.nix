{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
      highlight = "fg=#555555,bold";
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "regexp" "root" "line"];
    };
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
    historySubstringSearch.enable = true;
    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
      append = true;
      share = true;
      extended = true;
      ignoreAllDups = true;
    };

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

    history.path = "${config.xdg.dataHome}/zsh/history";

    initContent = ''
      # Start UWSM
      if uwsm check may-start > /dev/null && uwsm select; then
        exec systemd-cat -t uwsm_start uwsm start default
      fi

      # Completion styling
      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
      zstyle ':fzf-tab:*' use-fzf-default-opts yes
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # Shell function for initializing a project template
      nt() {
        if [ -z "$1" ]; then
          echo "Usage: nt <template-name>"
          return 1
        fi
        nix flake init --template "github:Marcus441/nix-templates/main#$1"
      }

    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "zoxide"
      ];
      theme = "robbyrussell";
    };
  };
}
