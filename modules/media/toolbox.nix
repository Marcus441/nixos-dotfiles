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
        audioMixer.command = "pavucontrol";
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
