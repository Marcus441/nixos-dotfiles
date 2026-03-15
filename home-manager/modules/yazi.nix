{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    plugins = {
      inherit (pkgs.yaziPlugins) lazygit;
      inherit (pkgs.yaziPlugins) full-border;
      inherit (pkgs.yaziPlugins) git;
      inherit (pkgs.yaziPlugins) smart-enter;
    };

    initLua = ''
      require("lazygit"):setup()
      require("full-border"):setup {
        type = ui.Border.PLAIN,
      }

      require("git"):setup()
      require("smart-enter"):setup {
        open_multi = true,
      }
    '';
  };
}
