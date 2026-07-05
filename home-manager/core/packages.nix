{pkgs, ...}: {
  # Essential packages shared by every profile (suckless + maximal). Profile
  # -specific / heavy GUI apps live in home-manager/profiles/<profile>/packages.nix.
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

    # Archive
    unzip
    zip

    # Other
    nix-prefetch-scripts
  ];
}
