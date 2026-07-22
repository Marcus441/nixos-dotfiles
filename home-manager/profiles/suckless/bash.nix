{
  config,
  lib,
  ...
}: let
  inherit (config.suckless) colors;

  # hex ("#rrggbb") -> "r;g;b" for ANSI truecolor escapes.
  hexPair = s: let
    digit = c:
      {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      }
      .${
        lib.toLower c
      };
    cs = lib.stringToCharacters s;
  in
    digit (builtins.elemAt cs 0) * 16 + digit (builtins.elemAt cs 1);
  rgb = hex: let
    h = lib.removePrefix "#" hex;
  in "${toString (hexPair (builtins.substring 0 2 h))};${toString (hexPair (builtins.substring 2 2 h))};${toString (hexPair (builtins.substring 4 2 h))}";
in {
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

      # Coloured man pages, using the base24 Kanagawa Dragon palette (./colors.nix)
      # via less' termcap hooks (truecolor escapes). Colour scheme adapted from
      # https://gist.github.com/bahamas10/542875bb47990933638d2b7dfaa501bf
      export GROFF_NO_SGR=1
      export LESS_TERMCAP_mb=$'\e[1;38;2;${rgb colors.base08}m'                              # blink       -> bold red
      export LESS_TERMCAP_md=$'\e[1;38;2;${rgb colors.base08}m'                              # bold        -> bold red   (headings, commands)
      export LESS_TERMCAP_me=$'\e[0m'                                                        # reset
      export LESS_TERMCAP_so=$'\e[38;2;${rgb colors.base00}m\e[48;2;${rgb colors.base0A}m'   # standout -> dark on yellow (status/search)
      export LESS_TERMCAP_se=$'\e[0m'                                                        # reset standout
      export LESS_TERMCAP_us=$'\e[4;1;38;2;${rgb colors.base0B}m'                            # underline   -> bold green  (args, options)
      export LESS_TERMCAP_ue=$'\e[0m'                                                        # reset underline
      export LESS_TERMCAP_mr=$'\e[7m'                                                        # reverse     -> inverse
      export LESS_TERMCAP_mh=$'\e[2m'                                                        # half-bright -> dim
    '';
  };
}
