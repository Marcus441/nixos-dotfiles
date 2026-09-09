_: {
  flake.modules.homeManager.apps = [
    (
      {pkgs, ...}: {
        programs.yazi = {
          enable = true;
          shellWrapperName = "y";

          settings = {
            plugin = {
              prepend_fetchers = [
                {
                  url = "*";
                  run = "git";
                  group = "git";
                }
                {
                  url = "*/";
                  run = "git";
                  group = "git";
                }
              ];
            };
          };

          plugins = {
            inherit (pkgs.yaziPlugins) git;
          };

          initLua = ''
            require("git"):setup()
          '';
        };
      }
    )
  ];
}
