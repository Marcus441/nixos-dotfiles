{...}: {
  flake.modules.nixos.core = [
    (
      {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          gh
          home-manager
          htop
          iw
          wget
        ];
      }
    )
  ];
}
