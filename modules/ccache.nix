_: {
  flake.modules.homeManager.dev = [
    (
      {
        pkgs,
        config,
        ...
      }: {
        home = {
          packages = with pkgs; [ccache];
          sessionVariables = {
            CCACHE_DIR = "${config.xdg.cacheHome}/ccache";
            CMAKE_C_COMPILER_LAUNCHER = "ccache";
            CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
          };
        };
      }
    )
  ];
}
