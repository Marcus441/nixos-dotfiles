_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        # By class, not the `floating-app` app-id: pavucontrol has no --app-id
        # flag, so every instance floats. See ./../floating-windows.nix.
        windowTags.floating-window = ["^(org.pulseaudio.pavucontrol)$"];

        home.packages = with pkgs; [
          imv
          ffmpeg
          imagemagick
          mediainfo
          pavucontrol
          playerctl
          yt-dlp
        ];
      }
    )
  ];
}
