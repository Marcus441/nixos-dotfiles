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
    };

    interactiveShellInit = ''
      set fish_greeting ""
      fish_vi_key_bindings

      set -l foreground DCD7BA normal
      set -l selection 2D4F67 brcyan
      set -l comment 727169 brblack
      set -l red C34043 red
      set -l orange FF9E64 brred
      set -l yellow C0A36E yellow
      set -l green 76946A green
      set -l purple 957FB8 magenta
      set -l cyan 7AA89F cyan
      set -l pink D27E99 brmagenta

      # Syntax Highlighting Colors
      set -g fish_color_normal $foreground
      set -g fish_color_command $cyan
      set -g fish_color_keyword $pink
      set -g fish_color_quote $yellow
      set -g fish_color_redirection $foreground
      set -g fish_color_end $orange
      set -g fish_color_error $red
      set -g fish_color_param $purple
      set -g fish_color_comment $comment
      set -g fish_color_selection --background=$selection
      set -g fish_color_search_match --background=$selection
      set -g fish_color_operator $green
      set -g fish_color_escape $pink
      set -g fish_color_autosuggestion $comment

      # Completion Pager Colors
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment

      # LS_COLORS
      set -x LS_COLORS "di=1;34:fi=1;33:ex=32:ln=1;36:*.sh=32:*.md=1;34:*.nix=36:*.py=35:*.rs=33"
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
