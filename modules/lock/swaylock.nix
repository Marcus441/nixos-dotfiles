_: {
  flake.modules.homeManager.dwl = [
    (
      {
        config,
        lib,
        ...
      }: let
        inherit (lib.mapAttrs (_: lib.removePrefix "#") config.desktop.colors) base00 base01 base03 base05 base08 base0A base0B base0D;
        inherit (config.desktop) font;
      in {
        programs.swaylock = {
          enable = true;
          settings = {
            color = base00;
            font = font.name;
            font-size = font.terminalSize;

            indicator-radius = 100;
            indicator-thickness = 8;
            indicator-caps-lock = true;

            inside-color = base00;
            inside-clear-color = base00;
            inside-ver-color = base00;
            inside-wrong-color = base00;

            ring-color = base03;
            ring-clear-color = base0A;
            ring-ver-color = base0D;
            ring-wrong-color = base08;

            key-hl-color = base0B;
            bs-hl-color = base08;
            caps-lock-key-hl-color = base0A;
            caps-lock-bs-hl-color = base08;

            layout-bg-color = base01;
            layout-border-color = base03;
            layout-text-color = base05;

            line-color = base00;
            line-clear-color = base00;
            line-ver-color = base00;
            line-wrong-color = base00;
            separator-color = base00;

            text-color = base05;
            text-clear-color = base05;
            text-ver-color = base05;
            text-wrong-color = base05;

            ignore-empty-password = true;
            show-failed-attempts = true;
          };
        };
      }
    )
  ];

  flake.modules.nixos.dwl = [
    {
      # load-bearing: docs/decisions/sessions.md#swaylock-pam
      security.pam.services.swaylock = {};
    }
  ];
}
