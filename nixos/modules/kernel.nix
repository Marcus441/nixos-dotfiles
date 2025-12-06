{
  pkgs,
  config,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = with config.boot.kernelPackages; [
      rtl8852bu
    ];
    modprobeConfig.enable = true;
    extraModprobeConfig = ''
      options 8852bu rtw_switch_usb_mode=1 rtw_he_enable=1 rtw_vht_enable=1
    '';
  };
}
