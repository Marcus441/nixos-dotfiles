_: {
  flake.modules.homeManager.core = [
    {
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
          # Globbing: **, extended patterns, empty expansion, cd typo correction.
          shopt -s globstar extglob nullglob dirspell cdspell
        '';
      };

      programs.readline = {
        enable = true;
        variables = {
          completion-ignore-case = true;
          completion-map-case = true;
          show-all-if-ambiguous = true;
          mark-directories = true;
          mark-symlinked-directories = true;
          skip-completed-text = true;
          colored-stats = true;
        };
      };
    }
  ];

  flake.modules.homeManager.hyprland = [
    {
      programs.bash.profileExtra = ''
        if uwsm check may-start > /dev/null && uwsm select; then
          uwsm start default | systemd-cat -t uwsm_start
        fi
      '';
    }
  ];
}
