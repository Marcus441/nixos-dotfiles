{...}: {
  flake.modules.nixos.dev = [
    (
      {...}: {
        imports = [
          {
            boot.binfmt = {
              emulatedSystems = ["aarch64-linux"];
            };
          }
          {
            virtualisation.docker = {
              enable = true;
              enableOnBoot = false;
            };
          }
          (
            {pkgs, ...}: {
              services.usbmuxd = {
                enable = true;
                # package = pkgs.usbmuxd2; # use this if cant connect
              };
              environment.systemPackages = with pkgs; [
                libimobiledevice
                # ifuse # optional, to mount using 'ifuse'
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
