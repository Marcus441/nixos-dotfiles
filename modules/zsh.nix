_: {
  flake.modules.homeManager.zsh = [
    (
      {config, ...}: let
        inherit (config.desktop) colors16;
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

          initContent = ''
            # Globbing: extended patterns, and empty expansion in place of the
            # default error. ** is recursive without an option.
            setopt extended_glob null_glob

            # Completion: case- and separator-insensitive, approximate matches
            # last, LS_COLORS in an arrow-navigable menu, list on first tab.
            zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}'
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
            zstyle ':completion:*' menu select
            unsetopt list_ambiguous

            # /etc/zshrc bound these into the keymap that was main before
            # defaultKeymap relinked it.
            [[ -r /etc/zinputrc ]] && source /etc/zinputrc
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
