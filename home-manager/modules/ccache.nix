{pkgs, ...}: {
  home = {
    packages = with pkgs; [ccache];
    sessionVariables = {
      CCACHE_DIR = "/var/cache/ccache";
      CMAKE_C_COMPILER_LAUNCHER = "ccache";
      CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
    };
  };
}
