_: {
  flake.modules.nixos.nvidia = [
    (
      {config, ...}: {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        services.xserver.videoDrivers = ["nvidia"];

        hardware.nvidia = {
          modesetting.enable = true;

          # load-bearing: docs/decisions/gaming.md#nvidia-preserve-vram
          powerManagement.enable = true;

          powerManagement.finegrained = false;
          open = true;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.latest;

          moduleParams.nvidia.NVreg_UsePageAttributeTable = 1;
        };
      }
    )
  ];

  flake.modules.homeManager.nvidia = [
    {
      home.sessionVariables.__GL_VRR_ALLOWED = "1";
    }
  ];
}
