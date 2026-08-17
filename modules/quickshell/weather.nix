_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.weather = {
          latitude = lib.mkOption {
            type = lib.types.str;
            default = "-27.4705";
            description = "Latitude the bar's weather readout queries.";
          };
          longitude = lib.mkOption {
            type = lib.types.str;
            default = "153.0260";
            description = "Longitude the bar's weather readout queries.";
          };
          timezone = lib.mkOption {
            type = lib.types.str;
            default = "Australia/Brisbane";
            description = "IANA timezone the bar's weather readout queries.";
          };
        };
      }
    )
  ];
}
