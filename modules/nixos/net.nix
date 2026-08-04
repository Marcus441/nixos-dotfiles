{...}: {
  flake.modules.nixos.core = [
    (
      {lib, ...}: {
        systemd.services.NetworkManager-wait-online.enable = false;
        networking = {
          hosts = {
            "192.168.1.1" = ["routerlogin.net" "www.routerlogin.net"];
          };
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
