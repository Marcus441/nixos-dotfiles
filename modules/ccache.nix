_: {
  flake.modules.homeManager.dev = [
    (
      # ccache + CMake launcher env for out-of-nix C/C++ builds.
      {pkgs, ...}: {
        home = {
          packages = with pkgs; [ccache];
          sessionVariables = {
            CCACHE_DIR = "$HOME/.cache/ccache";
            CMAKE_C_COMPILER_LAUNCHER = "ccache";
            CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
          };
        };
      }
    )
  ];
}
