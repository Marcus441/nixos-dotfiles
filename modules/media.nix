{...}: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
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
