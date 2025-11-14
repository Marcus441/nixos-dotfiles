{
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd = {
      settings = {
        Settings = {AutoConnect = true;};
        AddressRandomization = {
          Enable = true;
          Persistent = true;
        };
      };
    };
  };
}
