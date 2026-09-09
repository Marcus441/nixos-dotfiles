_: {
  flake.modules.homeManager.nvidia = [
    {
      home.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    }
  ];
}
