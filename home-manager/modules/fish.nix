{pkgs, ...}: {
  programs.fish = {
    enable = true;
    binds = {
      "alt-s" = {
        erase = true;
        operate = "preset";
        mode = "insert";
      };
    };

    functions = {
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';

      nt = ''
        if test (count $argv) -lt 1
            echo "Usage: nt <template-name>"
            return 1
        end

        nix flake init --template "github:Marcus441/nix-templates/main#$argv[1]"
      '';
      # --- TMUX Title Functions for Clean Window Status ---

      fish_preexec = ''
        if test -n "$TMUX"
          # Set the pane title to the command being run
          tmux select-pane -T "$argv"
        end
      '';

      fish_postexec = ''
        if test -n "$TMUX"
          # Reset the pane title to the current directory basename
          # This keeps the window name clean when waiting for input
          tmux select-pane -T (basename (pwd))
        end
      '';
    };

    interactiveShellInit = ''
      set -g fish_greeting
      fish_vi_key_bindings

      if test -n "$TMUX"
        tmux select-pane -T (basename (pwd))
      end

      if status is-interactive
        if test "$SHLVL" = 1; and not set -q TMUX
          fastfetch
        end
      end
    '';

    loginShellInit = ''
      # Start workspace manager once per login
      if uwsm check may-start > /dev/null; and uwsm select
          uwsm start default | systemd-cat -t uwsm_start
      end
    '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          sha256 = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
    ];

    shellAbbrs = {
      lsa = "ls -lah";
      ta = "tmux attach";

      ost = "nh os test";
      osw = "nh os switch";
      hms = "nh home switch";
      upd = "nh os switch --update";
      nd = "nix develop -c $SHELL";
      ndi = "nix develop --impure -c $SHELL";

      pkgs = "nvim ~/flake/home-manager/home-packages.nix";

      vim = "nvim";

      # GIT
      gs = "git status";
      gc = "git checkout";
      gl = "git log --oneline --graph --decorate | bat";
    };

    shellAliases = {};
  };
}
