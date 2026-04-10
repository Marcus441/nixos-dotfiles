{
  # Faster boot time, does not wait to connect to internet on boot
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
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
