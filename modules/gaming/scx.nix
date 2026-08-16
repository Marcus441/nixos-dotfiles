_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        services.scx = {
          enable = true;

          # load-bearing: docs/decisions/gaming.md#scx-package
          package = pkgs.scx.rustscheds;

          scheduler = "scx_lavd";
        };
      }
    )
  ];
}
