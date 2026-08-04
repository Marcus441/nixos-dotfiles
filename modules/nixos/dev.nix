{...}: {
  flake.modules.nixos.dev = [
    (
      {
        dev,
        lib,
        ...
      }: {
        imports = lib.optionals dev [
          ../../nixos/dev/binfmt.nix
          ../../nixos/dev/docker.nix
          ../../nixos/dev/libimobiledevice.nix
          ../../nixos/dev/qemu.nix
        ];
      }
    )
  ];
}
