{
  pkgs,
  config,
  ...
}: {
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

      # Base16 color mapping from Stylix
      set -l base00 ${config.lib.stylix.colors.base00} # Background
      set -l base01 ${config.lib.stylix.colors.base01}
      set -l base02 ${config.lib.stylix.colors.base02}
      set -l base03 ${config.lib.stylix.colors.base03}
      set -l base04 ${config.lib.stylix.colors.base04}
      set -l base05 ${config.lib.stylix.colors.base05} # Foreground
      set -l base06 ${config.lib.stylix.colors.base06}
      set -l base07 ${config.lib.stylix.colors.base07}
      set -l base08 ${config.lib.stylix.colors.base08} # Red
      set -l base09 ${config.lib.stylix.colors.base09} # Orange
      set -l base0A ${config.lib.stylix.colors.base0A} # Yellow
      set -l base0B ${config.lib.stylix.colors.base0B} # Green
      set -l base0C ${config.lib.stylix.colors.base0C} # Cyan
      set -l base0D ${config.lib.stylix.colors.base0D} # Blue
      set -l base0E ${config.lib.stylix.colors.base0E} # Purple
      set -l base0F ${config.lib.stylix.colors.base0F} # Pink/Bright Red

      # Semantic assignments
      set -l foreground $base05
      set -l selection $base02
      set -l comment $base03
      set -l red $base08
      set -l orange $base09
      set -l yellow $base0A
      set -l green $base0B
      set -l cyan $base0C
      set -l purple $base0E
      set -l pink $base0F

      # Syntax Highlighting
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

      # Completion Pager
      set -g fish_pager_color_progress $comment
      set -g fish_pager_color_prefix $cyan
      set -g fish_pager_color_completion $foreground
      set -g fish_pager_color_description $comment
      set -g fish_pager_color_selected_background --background=$selection
      set -g fish_pager_color_selected_prefix $cyan
      set -g fish_pager_color_selected_completion $foreground
      set -g fish_pager_color_selected_description $comment

      # LS_COLORS (Base16-inspired mapping)
      set -x LS_COLORS "di=1;34:fi=0:$base05:ex=32:ln=1;36:*.sh=32:*.md=1;34:*.nix=36:*.py=35:*.rs=33"

      fastfetch
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
