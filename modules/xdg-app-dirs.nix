_: {
  flake.modules.homeManager.core = [
    (
      {config, ...}: {
        home.sessionVariables = {
          XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
        };
      }
    )
  ];

  flake.modules.homeManager.dev = [
    (
      {config, ...}: {
        home.sessionVariables = {
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
          GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
          # load-bearing: docs/decisions/xdg.md#android-user-home
          ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
          DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
          NUGET_PACKAGES = "${config.xdg.cacheHome}/nuget/packages";
          NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          EM_CACHE = "${config.xdg.cacheHome}/emscripten";
          DOCKER_CONFIG = "${config.xdg.configHome}/docker";
          TF_CLI_CONFIG_FILE = "${config.xdg.configHome}/terraform/terraformrc";
          TF_PLUGIN_CACHE_DIR = "${config.xdg.cacheHome}/terraform/plugins";
          NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
          PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
        };

        xdg.stateFile."node/.keep".text = "";
        xdg.stateFile."python/.keep".text = "";
      }
    )
  ];
}
