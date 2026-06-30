{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qemu_kvm
    quickemu
    binutils
  ];
}
