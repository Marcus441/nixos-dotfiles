_: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          ffmpeg
          imagemagick
          mediainfo
          yt-dlp
        ];
      }
    )
  ];

  flake.modules.homeManager.wayland = [
    (
      {pkgs, ...}: {
        home.packages = with pkgs; [
          imv
          playerctl
        ];
      }
    )
  ];
}
