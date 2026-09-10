_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          dnsutils
          httpie
        ];
      }
    )
  ];

  flake.modules.nixos.core = [
    ({pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        iw
        wget
      ];
    })
    (
      {lib, ...}: {
        systemd.services.NetworkManager-wait-online.enable = false;
        networking = {
          networkmanager = {
            enable = true;
            wifi = {
              powersave = lib.mkDefault false;
              backend = "iwd";
            };
          };
          wireless.iwd = {
            settings = {
              Settings.AutoConnect = true;
              Network = {
                AddressRandomization = "network";
                AddressRandomizationRange = "full";
              };
            };
          };
        };
      }
    )
  ];
}
