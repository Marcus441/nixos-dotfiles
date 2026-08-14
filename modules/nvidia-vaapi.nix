_: {
  flake.modules.homeManager.nvidia = [
    {
      # load-bearing: docs/decisions/gaming.md#vaapi-decode-only
      home.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    }
  ];
}
