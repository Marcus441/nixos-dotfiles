{pkgs, ...}: {
  # Essential packages shared by every profile (suckless + maximal). Profile
  # -specific / heavy GUI apps live in home-manager/profiles/<profile>/packages.nix.
  home.packages = with pkgs; [
    # Desktop apps
    imv

    # Document & Image Rendering (for Neovim/Snacks)
    ghostscript
    tectonic

    # Screen & Clipboard (compositor-agnostic)
    wl-clipboard
    wtype
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
    nmap
    man-pages
    man-pages-posix

    # Archive
    unzip
    zip

    # Other
    bemoji
    nix-prefetch-scripts
    silicon
  ];
}
