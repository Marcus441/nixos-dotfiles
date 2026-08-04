{...}: {
  hosts.swift5 = {
    hostname = "swift5";
    system = "x86_64-linux";
    stateVersion = "25.11";
    profile = "suckless";
    dev = true;
    aspects = ["dev" "core"];
  };
}
