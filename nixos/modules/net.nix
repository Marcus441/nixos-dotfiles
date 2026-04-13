{
  # Faster boot time, does not wait to connect to internet on boot
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    hosts = {
      "192.168.1.1" = ["routerlogin.net" "www.routerlogin.net"];
    };
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
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
