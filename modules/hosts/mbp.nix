_: {
  hosts.mbp = {
    hostname = "mbp";
    system = "aarch64-darwin";
    stateVersion = 7;
    aspects = ["dev" "core" "kitty" "zsh" "apps" "office" "xcode" "vscode"];

    fontSize = 24;

    hardware = null;

    machine = {
      stateVersion,
      hostname,
      ...
    }: {
      networking = {
        hostName = hostname;
        computerName = hostname;
        localHostName = hostname;
      };

      system.stateVersion = stateVersion;
    };
  };
}
