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
          ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
          ANDROID_EMULATOR_HOME = "${config.xdg.dataHome}/android";
          ANDROID_HOME = "${config.xdg.dataHome}/android/sdk";
          DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
          NUGET_PACKAGES = "${config.xdg.cacheHome}/nuget/packages";
          NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
          NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
          EM_CACHE = "${config.xdg.cacheHome}/emscripten";
          DOCKER_CONFIG = "${config.xdg.configHome}/docker";
          TF_CLI_CONFIG_FILE = "${config.xdg.configHome}/terraform/terraformrc";
          TF_PLUGIN_CACHE_DIR = "${config.xdg.cacheHome}/terraform/plugins";
          AWS_CONFIG_FILE = "${config.xdg.configHome}/aws/config";
          AWS_SHARED_CREDENTIALS_FILE = "${config.xdg.configHome}/aws/credentials";
          AWS_LOGIN_CACHE_DIRECTORY = "${config.xdg.cacheHome}/aws/login";
          GOPATH = "${config.xdg.dataHome}/go";
          GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
          PSQLRC = "${config.xdg.configHome}/pg/psqlrc";
          PGPASSFILE = "${config.xdg.configHome}/pg/pgpass";
          PGSERVICEFILE = "${config.xdg.configHome}/pg/pg_service.conf";
          NODE_REPL_HISTORY = "${config.xdg.stateHome}/node/repl_history";
          PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
          PSQL_HISTORY = "${config.xdg.stateHome}/psql/history";
        };

        xdg.stateFile."node/.keep".text = "";
        xdg.stateFile."python/.keep".text = "";
        xdg.stateFile."psql/.keep".text = "";
      }
    )
  ];
}
