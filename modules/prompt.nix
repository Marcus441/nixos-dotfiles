_: let
  slot = {
    cwd = "base0D";
    git = "base0E";
    env = "base0C";
    ok = "base03";
    err = "base08";
  };
in {
  flake.modules.homeManager.core = [
    (
      {config, ...}: let
        inherit (config.desktop) colorsRgb;
      in {
        programs.bash.initExtra = ''
          # OSC 7: report the working directory so foot can spawn new
          # instances (and footclient windows) in the current directory.
          __osc7_cwd() { printf '\e]7;file://%s%s\e\\' "''${HOSTNAME:-$(hostname)}" "$PWD"; }

          # Prompt: cwd + git branch + active dev environment (devenv / nix
          # devshell / python venv) + a "$" sigil, in the base24 palette.
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
}
