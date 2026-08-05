{...}: {
  flake.modules.homeManager.core = [
    (
      {pkgs, ...}: {
        # Essential packages shared by every host. Aspect-specific / heavy GUI
        # apps live in modules/<aspect>/packages.nix.
        home.packages = with pkgs; [
          # Desktop apps
          imv

          # Screen & Clipboard (compositor-agnostic)
          wl-clipboard
          cliphist

          # Media
          ffmpeg
          imagemagick
          mediainfo
          pavucontrol
          playerctl
          yt-dlp

          # Network & System
          bc
          brightnessctl
          dnsutils
          httpie
          man-pages
          man-pages-posix

          # Files
          tree

          # Archive
          unzip
          zip

          # Other
          nix-prefetch-scripts
        ];
      }
    )
  ];
}
