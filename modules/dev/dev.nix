_: {
  flake.modules.nixos.dev = [
    (
      {...}: {
        imports = [
          {
            boot.binfmt = {
              emulatedSystems = ["aarch64-linux"];
            };
          }
          (
            {pkgs, ...}: {
              services.usbmuxd = {
                enable = true;
              };
              environment.systemPackages = with pkgs; [
                libimobiledevice
              ];
            }
          )
          (
            {pkgs, ...}: {
              environment.systemPackages = with pkgs; [
                qemu_kvm
                quickemu
              ];
            }
          )
        ];
      }
    )
  ];
}
