_: {
  flake.modules.nixos.core = [
    {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          # load-bearing: docs/decisions/display-and-boot.md#boot-timeout
          timeout = 0;
          efi.canTouchEfiVariables = true;
        };

        consoleLogLevel = 0;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "loglevel=3"
          "rd.systemd.show_status=false"
          "rd.udev.log_level=3"
          "udev.log_priority=3"
        ];
      };
    }
  ];
}
