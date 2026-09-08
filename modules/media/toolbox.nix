_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.audioMixer.command = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Command opening an audio-mixer UI, bare of any session launcher prefix. Empty when no aspect provides one.";
        };
      }
    )
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
