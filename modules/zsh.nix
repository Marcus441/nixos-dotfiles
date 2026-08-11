_: {
  flake.modules.homeManager.zsh = [
    (
      {config, ...}: let
        inherit (config.desktop) colors16 colorsRgb;
      in {
        programs.zsh = {
          enable = true;

          # load-bearing: docs/decisions/shells.md#zsh-keymap
          defaultKeymap = "emacs";

          history = {
            size = 50000;
            save = 100000;
          };

          autosuggestion = {
            enable = true;
            highlight = "fg=${colors16.base03}";
          };

          syntaxHighlighting = {
            enable = true;
            styles = let
              command = "fg=${colors16.base0B}";
              string = "fg=${colors16.base0A}";
              substitution = "fg=${colors16.base0C}";
              filepath = "fg=${colors16.base0D}";
              plain = "fg=${colors16.base05}";
            in {
              default = plain;
              unknown-token = "fg=${colors16.base08}";
              reserved-word = "fg=${colors16.base0E}";
              comment = "fg=${colors16.base03}";

              alias = command;
              suffix-alias = command;
              global-alias = command;
              builtin = command;
              function = command;
              inherit command;
              precommand = command;
              hashed-command = command;
              arg0 = command;

              path = filepath;
              path_prefix = filepath;
              autodirectory = filepath;
              globbing = "fg=${colors16.base09}";
              history-expansion = "fg=${colors16.base0E}";

              single-quoted-argument = string;
              double-quoted-argument = string;
              dollar-quoted-argument = string;
              rc-quote = string;

              dollar-double-quoted-argument = substitution;
              back-double-quoted-argument = substitution;
              back-dollar-quoted-argument = substitution;
              back-quoted-argument = substitution;
              command-substitution-delimiter = substitution;
              process-substitution-delimiter = substitution;
              single-hyphen-option = substitution;
              double-hyphen-option = substitution;

              assign = plain;
              redirection = plain;
              commandseparator = plain;
              named-fd = plain;
              numeric-fd = plain;
            };
          };

          initContent = ''
            # Globbing: extended patterns, and empty expansion in place of the
            # default error. ** is recursive without an option.
            setopt extended_glob null_glob

            # Completion: case- and separator-insensitive, approximate matches
            # last, list on the first tab, arrow-navigable menu.
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*' menu select
            unsetopt list_ambiguous

            # Menu: file types from LS_COLORS, as ls prints them; the selected
            # row in the colours foot gives a terminal selection.
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} 'ma=48;2;${colorsRgb.base02};38;2;${colorsRgb.base06}'
            zstyle ':completion:*:descriptions' format '%F{${colors16.base0C}}%d%f'
            zstyle ':completion:*:messages' format '%F{${colors16.base03}}%d%f'
            zstyle ':completion:*:warnings' format '%F{${colors16.base08}}no matches%f'

            # /etc/zshrc bound these into the keymap that was main before
            # defaultKeymap relinked it.
            [[ -r /etc/zinputrc ]] && source /etc/zinputrc

            # C-x C-e: edit the line in $VISUAL, as readline binds by default.
            # Unlike readline's, it hands the line back rather than running it.
            autoload -Uz edit-command-line
            zle -N edit-command-line
            bindkey '^X^E' edit-command-line
          '';
        };
      }
    )
  ];

  flake.modules.nixos.zsh = [
    (
      {pkgs, ...}: {
        programs.zsh = {
          # load-bearing: docs/decisions/shells.md#zsh-nixos-surface
          enable = true;
          promptInit = "";
          enableGlobalCompInit = false;
        };

        loginShell = pkgs.zsh;
      }
    )
  ];
}
