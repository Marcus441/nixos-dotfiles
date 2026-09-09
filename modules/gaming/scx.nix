_: {
  flake.modules.nixos.gaming = [
    (
      {pkgs, ...}: {
        services.scx = {
          enable = true;

          package = pkgs.scx.rustscheds;

          scheduler = "scx_lavd";
        };
      }
    )
  ];
}
