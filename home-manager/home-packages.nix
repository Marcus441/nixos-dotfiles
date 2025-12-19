{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop apps
    imv
    kdePackages.kdenlive
    mpv
    obs-studio
    thunderbird-latest

    # CLI utils
    bc
    brightnessctl
    cliphist
    dnsutils
    fd
    ffmpeg
    git-graph
    grimblast
    htop
    httpie
    hyprpicker
    imagemagick
    jq
    mediainfo
    nmap
    ntfs3g
    playerctl
    ripgrep
    silicon
    udisks
    ueberzugpp
    unzip
    usbutils
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip

    # WM stuff
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # make
    gnumake

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}
