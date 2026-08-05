{config, ...}: let
  top = config;
in {
  flake.modules.homeManager.suckless = [
    (
      {
        pkgs,
        lib,
        hostname,
        monitors,
        ...
      }: {
        assertions = top.flake.lib.monitors.assertionsFor hostname monitors;

        home.packages = [
          (pkgs.writeShellApplication {
            name = "dwl-monitors";
            runtimeInputs = [pkgs.wlr-randr];
            text = lib.concatMapStringsSep "\n" top.flake.lib.monitors.toWlrRandr monitors;
          })
        ];
      }
    )
  ];
}
