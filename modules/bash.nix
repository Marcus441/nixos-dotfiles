_: {
  flake.modules.homeManager.core = [
    (
      {config, ...}: let
        inherit (config.desktop) colorsRgb;
      in {
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
            # Coloured man pages via less' termcap hooks. Scheme adapted from
            # https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf
            export GROFF_NO_SGR=1
            export LESS_TERMCAP_mb=$'\e[1;38;2;${colorsRgb.base08}m'
            export LESS_TERMCAP_md=$'\e[1;38;2;${colorsRgb.base08}m'
            export LESS_TERMCAP_me=$'\e[0m'
            export LESS_TERMCAP_so=$'\e[38;2;${colorsRgb.base00}m\e[48;2;${colorsRgb.base0A}m'
            export LESS_TERMCAP_se=$'\e[0m'
            export LESS_TERMCAP_us=$'\e[4;1;38;2;${colorsRgb.base0B}m'
            export LESS_TERMCAP_ue=$'\e[0m'
            export LESS_TERMCAP_mr=$'\e[7m'
            export LESS_TERMCAP_mh=$'\e[2m'

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
    )
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
