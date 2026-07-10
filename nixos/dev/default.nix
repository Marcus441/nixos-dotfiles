# Dev tooling (containers, VMs, cross-arch emulation), gated per host by the
# `dev` flag in flake.nix. Imported unconditionally from ../core; hosts with
# dev = false pay nothing. Compilers are deliberately absent -- project
# toolchains come from devshells (github.com/Marcus441/nix-templates).
{
  dev,
  lib,
  ...
}: {
  imports = lib.optionals dev [
    ./binfmt.nix
    ./docker.nix
    ./qemu.nix
  ];
}
