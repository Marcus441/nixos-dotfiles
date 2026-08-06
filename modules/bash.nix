{...}: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        ...
      }: let
        inherit (config.desktop) colors;

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
        # Shared bash config for all profiles. fzf (Ctrl+R) and zoxide live here in
        # core, direnv in the maximal profile; all three wire themselves into bash
        # automatically via their default bash integration.
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

            # Prompt: cwd + git branch + active dev environment (devenv / nix
            # devshell / python venv) + white "$", using the base24 palette
            # (./colors.nix). Replaced starship in step 1.2; no external prompt
            # program.
            __prompt() {
              local branch env=""
              branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)
              if [[ -n $DEVENV_ROOT ]]; then
                env="devenv"
              elif [[ -n $IN_NIX_SHELL ]]; then
                env="nix"
              fi
              [[ -n $VIRTUAL_ENV ]] && env="''${env:+$env,}venv:''${VIRTUAL_ENV##*/}"
              PS1='\[\e[1;38;2;${rgb colors.base0D}m\]\w\[\e[0m\]'
              [[ -n $branch ]] && PS1+=" \[\e[38;2;${rgb colors.base0E}m\]git:$branch\[\e[0m\]"
              [[ -n $env ]] && PS1+=" \[\e[38;2;${rgb colors.base0C}m\]($env)\[\e[0m\]"
              PS1+=' \[\e[1;38;2;${rgb colors.base05}m\]\$\[\e[0m\] '
            }
            case "$PROMPT_COMMAND" in
              *__prompt*) ;;
              *) PROMPT_COMMAND="__prompt;__osc7_cwd''${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
            esac

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
    )
  ];

  flake.modules.homeManager.maximal = [
    {
      programs.bash = {
        shellAliases = {
          nd = "nix develop -c $SHELL";
          ndi = "nix develop --impure -c $SHELL";
          gs = "git status";
          gc = "git checkout";
          gg = "git-graph --style round";
          nt = "nix flake init --refresh --template github:Marcus441/nix-templates/main#";
          nf = "nix flake init --template templates#";
        };

        initExtra = ''
          # List TODO/FIXME/NOTE/HACK comments and open in nvim
          vtodo() {
            local result file line
            result=$(rg --color=always --line-number --no-heading \
                'TODO|FIXME|HACK|NOTE|BUG|WARN' \
              | fzf --ansi --height=60% --layout=reverse --border \
                    --delimiter=: \
                    --preview 'bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || cat {1}' \
                    --preview-window=right:55%:+{2}-5)
            if [[ -n $result ]]; then
              file=''${result%%:*}
              line=$(cut -d: -f2 <<<"$result")
              nvim +"$line" "$file"
            fi
          }
        '';
      };
    }
  ];

  # Session startup wearing shell clothing: the login shell is only the channel,
  # the decision is Hyprland.
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
