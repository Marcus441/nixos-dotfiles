{
  pkgs,
  config,
  ...
}: let
  settings = import ./yazi.nix;
  theme = import ./style.nix {inherit config;};
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    inherit settings;
    inherit theme;
    plugins = {
      inherit (pkgs.yaziPlugins) lazygit;
      inherit (pkgs.yaziPlugins) full-border;
      inherit (pkgs.yaziPlugins) git;
      inherit (pkgs.yaziPlugins) smart-enter;
    };

    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
      require("smart-enter"):setup { open_multi = true, }
    '';
  };
}
