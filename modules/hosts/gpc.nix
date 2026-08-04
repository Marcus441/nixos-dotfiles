{...}: {
  hosts.gpc = {
    hostname = "gpc";
    system = "x86_64-linux";
    stateVersion = "25.11";
    profile = "maximal";
    dev = false;
    aspects = ["dev" "core" "maximal"];
  };
}
