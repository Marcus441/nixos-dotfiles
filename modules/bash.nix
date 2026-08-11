_: {
  flake.modules.homeManager.core = [
    {
      home.shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -alh --color=auto";
        grep = "grep --color=auto";
      };

      programs.bash = {
        enable = true;

        historyControl = ["ignoredups" "ignorespace"];
        historyFileSize = 100000;
        historySize = 50000;

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
}
