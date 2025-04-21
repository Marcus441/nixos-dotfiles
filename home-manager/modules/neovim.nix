{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    # Directly give HM a list of plugins:
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      # other vimPlugins.* you want…
    ];
  };
}

