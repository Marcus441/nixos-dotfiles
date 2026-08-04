{...}: {
  flake.modules.nixos.core = [
    {
      time.timeZone = "Australia/Brisbane";
    }
  ];
}
