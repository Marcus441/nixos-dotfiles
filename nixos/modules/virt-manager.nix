{
  pkgs,
  user,
  ...
}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = ["virbr0"];
  users.users.${user}.extraGroups = ["libvirtd" "kvm"];
}
