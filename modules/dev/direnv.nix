_: {
  flake.modules.homeManager.apps = [
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config.global.hide_env_diff = true;
        # load-bearing: docs/decisions/shells.md#direnv-nix-json-for-neovim
        stdlib = ''
          if [[ -n ''${NVIM:-} && ! -t 2 ]]; then
            _nix() {
              "$_nix_direnv_nix" --log-format internal-json --no-warn-dirty \
                --extra-experimental-features "nix-command flakes" "$@"
            }
          fi
        '';
      };
    }
  ];
}
