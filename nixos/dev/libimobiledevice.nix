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
