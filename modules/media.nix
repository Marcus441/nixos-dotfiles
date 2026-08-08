_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
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
