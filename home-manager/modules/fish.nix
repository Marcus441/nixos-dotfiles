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

    functions.mkcd = {
      body = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';
      description = "Create a directory and cd into it";
      argumentNames = "dir";
    };

    interactiveShellInit = ''
      set -g fish_greeting
      fish_vi_key_bindings
    '';
    shellInitLast = ''
      if test "$SHLVL" = 1
        fastfetch
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
      ta = "tmux attach";

      ost = "nh os test";
      osw = "nh os switch";
      hms = "nh home switch";
      upd = "nh os switch --update";
      nd = "nix develop -c $SHELL";
      ndi = "nix develop --impure -c $SHELL";

      pkgs = "nvim ~/flake/home-manager/home-packages.nix";

      # GIT
      gs = "git status";
      gc = "git checkout";

      # templates
      nt = "nix flake init --refresh --template github:Marcus441/nix-templates/main#";
      nf = "nix flake init --template templates#";
    };

    shellAliases = {
      vim = "nvim";
      gg = "git-graph --style round";
    };
  };
}
