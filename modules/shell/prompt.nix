_: let
  slot = {
    cwd = "base0D";
    git = "base0E";
    env = "base0C";
    ok = "base03";
    err = "base08";
  };
  mark = {
    conflicted = " ";
    modified = " ";
    untracked = "? ";
    upToDate = " ";
    readOnly = " ";
  };
in {
  flake.modules.homeManager.core = [
    (
      {config, ...}: let
        inherit (config.desktop) colorsRgb;
      in {
        programs.bash.initExtra = ''
          # OSC 7: report the cwd, so a new window opens in it.
          __osc7_cwd() { printf '\e]7;file://%s%s\e\\' "''${HOSTNAME:-$(hostname)}" "$PWD"; }

          # Prompt: cwd, git branch, dev environment, and a "$" sigil.
          __prompt() {
            # Must be the first statement: anything else overwrites $?.
            local code=$?
            local branch env=""
            branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)
            if [[ -n $DEVENV_ROOT ]]; then
              env="devenv"
            elif [[ -n $IN_NIX_SHELL ]]; then
              env="nix"
            fi
            [[ -n $VIRTUAL_ENV ]] && env="''${env:+$env,}venv:''${VIRTUAL_ENV##*/}"
            PS1='\[\e[1;38;2;${colorsRgb.${slot.cwd}}m\]\w\[\e[0m\]'
            [[ -n $branch ]] && PS1+=" \[\e[38;2;${colorsRgb.${slot.git}}m\]git:$branch\[\e[0m\]"
            [[ -n $env ]] && PS1+=" \[\e[38;2;${colorsRgb.${slot.env}}m\]($env)\[\e[0m\]"
            local sigil="${colorsRgb.${slot.ok}}"
            [[ $code -ne 0 ]] && sigil="${colorsRgb.${slot.err}}"
            PS1+=" \[\e[38;2;''${sigil}m\]\\\$\[\e[0m\] "
          }
          case "$PROMPT_COMMAND" in
            *__prompt*) ;;
            *) PROMPT_COMMAND="__prompt;__osc7_cwd''${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
          esac
        '';
      }
    )
  ];

  flake.modules.homeManager.zsh = [
    (
      {config, ...}: let
        inherit (config.desktop) colors16;
      in {
        programs.zsh.initContent = ''
          autoload -Uz add-zsh-hook

          __prompt_sigil="%B%(?.%F{${colors16.${slot.ok}}}❯.%F{${colors16.${slot.err}}}✗)%f%b "

          # Prompt: a blank line, then cwd, git branch and status, dev
          # environment, and a sigil.
          __prompt() {
            local out line dir root branch="" oid="" gs="" ab="" env=""
            local it=$'\e[3m' ni=$'\e[23m'
            local conflicted="" modified="" untracked=""
            local -i ahead=0 behind=0 upstream=0 inrepo=0

            if out=$(command git --no-optional-locks status \
                       --porcelain=v2 --branch 2>/dev/null); then
              inrepo=1
              for line in ''${(f)out}; do
                case $line in
                  ('# branch.head '*) branch=''${line#\# branch.head } ;;
                  ('# branch.oid '*) oid=''${line#\# branch.oid } ;;
                  ('# branch.ab '*)
                    upstream=1
                    ahead=''${''${line#\# branch.ab +}%% *}
                    behind=''${line##*-} ;;
                  ([12]' '*)
                    [[ ''${line[4]} == [MT] ]] && modified="${mark.modified}" ;;
                  ('u '*) conflicted="${mark.conflicted}" ;;
                  ('? '*) untracked="${mark.untracked}" ;;
                esac
              done
            fi

            root=$PWD
            while [[ $root != / && ! -e $root/.git ]]; do root=''${root:h}; done
            [[ -e $root/.git && $root != $HOME ]] || root=""
            if [[ -n $root ]]; then
              dir=''${root:t}''${PWD#$root}
            elif [[ $PWD == "$HOME" ]]; then
              dir="~"
            elif [[ $PWD == "$HOME"/* ]]; then
              dir="~''${PWD#$HOME}"
            else
              dir=$PWD
            fi
            local -a parts=( ''${(s:/:)dir} )
            (( $#parts > 2 )) && dir="…/''${(j:/:)parts[-2,-1]}"

            if (( upstream )); then
              if (( ahead && behind )); then
                ab="⇕⇡''${ahead}⇣''${behind} "
              elif (( ahead )); then
                ab="⇡''${ahead} "
              elif (( behind )); then
                ab="⇣''${behind} "
              else
                ab="${mark.upToDate}"
              fi
            fi
            gs="$conflicted$modified$untracked$ab"

            if [[ -n $DEVENV_ROOT ]]; then
              env="devenv"
            elif [[ -n $IN_NIX_SHELL ]]; then
              env="nix"
            fi
            [[ -n $VIRTUAL_ENV ]] && env="''${env:+$env,}venv:''${VIRTUAL_ENV##*/}"

            if (( __prompt_topline )); then
              __prompt_topline=0
              PROMPT=""
            else
              PROMPT=$'\n'
            fi
            PROMPT+="%B%F{${colors16.${slot.cwd}}}''${dir//\%/%%}%f%b"
            [[ -w $PWD ]] || PROMPT+="%F{${colors16.${slot.err}}}${mark.readOnly}%f"
            PROMPT+=" "
            if (( inrepo )); then
              [[ $branch == '(detached)' ]] && branch=''${oid[1,7]}
              PROMPT+="%{$it%}%F{${colors16.${slot.git}}}''${branch//\%/%%}%f%{$ni%} "
              [[ -n $gs ]] && PROMPT+="%F{${colors16.${slot.git}}}$gs%f"
            fi
            [[ -n $env ]] && PROMPT+="%F{${colors16.${slot.env}}}(''${env//\%/%%})%f "
            PROMPT+=$__prompt_sigil
          }
          add-zsh-hook precmd __prompt

          # Transient: the sigil alone replaces the prompt a command was run
          # at, and a cleared screen drops the leading blank line.
          typeset -g __prompt_topline=1
          __prompt_transient() {
            PROMPT=$__prompt_sigil
            zle .reset-prompt
          }
          zmodload zsh/zle
          autoload -Uz add-zle-hook-widget
          add-zle-hook-widget line-finish __prompt_transient
          __prompt_clear() {
            __prompt_topline=1
            __prompt
            zle .clear-screen
          }
          zle -N clear-screen __prompt_clear
          __prompt_preexec() {
            [[ ''${1%% *} == (clear|reset) ]] && __prompt_topline=1
          }
          add-zsh-hook preexec __prompt_preexec

          # OSC 7: report the cwd, so a new window opens in it.
          __osc7_cwd() { printf '\e]7;file://%s%s\e\\' "$HOST" "$PWD" }
          add-zsh-hook precmd __osc7_cwd
        '';
      }
    )
  ];
}
