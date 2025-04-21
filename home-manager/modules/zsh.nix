{ pkgs, config, ... }: {
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
    shellAliases =
      let
        flakeDir = "~/flake";
      in {
        sw = "nh os switch";
        upd = "nh os switch --update";
        hms = "nh home switch";

        pkgs = "nvim ${flakeDir}/nixos/packages.nix";

        r = "ranger";
        v = "nvim";
        se = "sudoedit";
        microfetch = "microfetch && echo";

        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";

        ".." = "cd ..";
      };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
    
    initExtra = ''
      # Start Tmux automatically if not already running. No Tmux in TTY
      if [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
        tmux attach-session -t default || tmux new-session -s default
      fi

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
      '';
  };
}
