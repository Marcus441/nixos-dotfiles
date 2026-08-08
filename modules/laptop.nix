_: {
  # Deliberately small. power-profiles-daemon and upower stay in `core`:
  # waybar's battery module runs on the desktops too, and a too-small aspect is
  # recoverable where a broken power path is not.
  flake.modules.nixos.laptop = [
    {
      networking.networkmanager.wifi.powersave = true;
    }
  ];
}
