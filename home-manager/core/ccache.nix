# ccache + CMake launcher env for out-of-nix C/C++ builds; dev-tooling, so
# gated by the per-host `dev` flag (flake.nix) like nixos/dev.
{
  dev,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf dev {
    home = {
      packages = with pkgs; [ccache];
      sessionVariables = {
        CCACHE_DIR = "$HOME/.cache/ccache";
        CMAKE_C_COMPILER_LAUNCHER = "ccache";
        CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
      };
    };
  };
}
