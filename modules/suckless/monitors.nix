{...}: {
  flake.modules.homeManager.suckless = [
    (
      {
        pkgs,
        lib,
        monitors,
        ...
      }: let
        # Consume the neutral monitor data (the monitors block in
        # modules/hosts/<h>.nix) and render a wlr-randr invocation. wlr-randr
        # drives any wlroots compositor (incl. dwl), so the same host monitor
        # definitions work for both desktops.
        applyMonitor = m: ''
          wlr-randr --output ${m.name} \
            --mode ${toString m.width}x${toString m.height}@${toString m.refresh}Hz \
            --pos ${toString m.x},${toString m.y} \
            --scale ${toString m.scale} --on
        '';
      in {
        home.packages = [
          (pkgs.writeShellApplication {
            name = "dwl-monitors";
            runtimeInputs = [pkgs.wlr-randr];
            text = lib.concatMapStringsSep "\n" applyMonitor monitors;
          })
        ];
      }
    )
  ];
}
