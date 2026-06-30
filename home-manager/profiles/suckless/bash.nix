{
  # Bash is the suckless shell -- no fish, no starship prompt engine.
  # fzf (Ctrl+R), zoxide and direnv come from ../../core and wire themselves
  # into bash automatically via their default bash integration.
  programs.bash = {
    enable = true;

    historyControl = ["ignoredups" "ignorespace"];
    historyFileSize = 100000;
    historySize = 50000;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alh --color=auto";
      grep = "grep --color=auto";
    };

    initExtra = ''
      # OSC 7: report the working directory so foot can spawn new
      # instances (and footclient windows) in the current directory.
      __osc7_cwd() { printf '\e]7;file://%s%s\e\\' "''${HOSTNAME:-$(hostname)}" "$PWD"; }
      case "$PROMPT_COMMAND" in
        *__osc7_cwd*) ;;
        *) PROMPT_COMMAND="__osc7_cwd''${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
      esac

      # Minimal prompt (cwd + exit-status aware), no external prompt program.
      PS1='\[\e[1;34m\]\w\[\e[0m\] \$ '
    '';
  };
}
