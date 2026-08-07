_: {
  # Notifications are a capability, not a theming decision. The daemon lived in
  # `palette` and `stylix`, so a dwl host taking neither got no notifications at
  # all while `dwl.nix`'s autostart still invoked `mako` by bare name.
  flake.modules.homeManager.core = [
    {
      services.mako = {
        enable = true;

        # Placement and timing hold under either regime; only colour and
        # geometry differ, so the theming aspects below add just those.
        settings = {
          anchor = "top-right";
          default-timeout = 5000;
          border-size = 2;
          padding = 10;
        };

        # Per-summary timeouts for notifications either session can raise. Both
        # bind OCR -- dwl on super+c, Hyprland in its binds -- and ocr-copy
        # reports through notify-send. The screenshot rule is inert under dwl,
        # which pipes grim to wl-copy without notifying; it costs a line and
        # starts working if that ever changes.
        extraConfig = ''
          [app-name=notify-send summary="OCR*"]
          default-timeout=3000

          [summary="*screenshot*"]
          default-timeout=5000
        '';
      };
    }
  ];

  # Two theming regimes: palette colours mako from desktop.colors, stylix is
  # listed in the stylix target set and colours it itself.
  flake.modules.homeManager.palette = [
    (
      {config, ...}: let
        inherit (config.desktop) colors font;
      in {
        services.mako.settings = {
          font = "${font.name} ${toString font.size}";
          background-color = colors.base00;
          text-color = colors.base05;
          border-color = colors.base0D;
        };
      }
    )
  ];

  flake.modules.homeManager.stylix = [
    {
      # Geometry is deliberately not shared. These override mako's defaults
      # (max-icon-size 64, outer-margin 0, width 300, height 100) for the
      # 1440p and 4K desktops; swift5's 1080p panel keeps the defaults.
      services.mako.settings = {
        ignore-timeout = false;
        max-icon-size = 32;
        outer-margin = 20;
        width = 420;
        height = 110;
      };
    }
  ];

  # A battery warning is worth reading for longer, and the rule belongs to the
  # machine that has a battery rather than to a theming regime.
  flake.modules.homeManager.laptop = [
    {
      services.mako.extraConfig = ''
        [summary="*Battery*"]
        default-timeout=20000
      '';
    }
  ];
}
