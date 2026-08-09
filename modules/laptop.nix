_: {
  flake.modules.nixos.laptop = [
    {
      networking.networkmanager.wifi.powersave = true;
    }
  ];
}
