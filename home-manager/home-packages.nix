{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop apps
    imv
    kdePackages.kdenlive

    # Document & Image Rendering (for Neovim/Snacks)
    ghostscript
    tectonic

    # Screen & Clipboard
    grimblast
    hyprpicker
    wl-clipboard
    wtype
    cliphist
    (callPackage ./pkgs/ocr-copy.nix {})

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
    xdg-desktop-portal-gtk
  ];
}
