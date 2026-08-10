_: {
  flake.modules.homeManager.dwl = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        # load-bearing: docs/decisions/sessions.md#dwl-idle-dpms
        lockNow = "pgrep -x swaylock > /dev/null || swaylock -f";
      in {
        home.packages = [
          (pkgs.writeShellApplication {
            name = "dwl-idle";
            runtimeInputs = [
              pkgs.swayidle
              pkgs.brightnessctl
              pkgs.wlopm
              pkgs.procps
              config.programs.swaylock.package
            ];
            text = ''
              exec swayidle -w \
                timeout 180 'brightnessctl -s set 30' resume 'brightnessctl -r' \
                timeout 300 '${config.lock.command}' \
                timeout 600 'wlopm --off "*"' resume 'wlopm --on "*"' \
                timeout 1200 'systemctl suspend' \
                before-sleep '${lockNow}' \
                after-resume 'wlopm --on "*"' \
                lock '${lockNow}'
            '';
          })
        ];
      }
    )
  ];

  # load-bearing: docs/decisions/sessions.md#dwl-autostart
  flake.modules.nixos.dwl = [
    {dwl.autostart = ["dwl-idle"];}
  ];
}
