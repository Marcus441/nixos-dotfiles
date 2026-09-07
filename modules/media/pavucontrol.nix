_: {
  flake.modules.homeManager.wayland = [
    (
      {pkgs, ...}: {
        audioMixer.command = "pavucontrol";
        windowTags.floating-window = ["^(org.pulseaudio.pavucontrol)$"];

        home.packages = [pkgs.pavucontrol];
      }
    )
  ];
}
