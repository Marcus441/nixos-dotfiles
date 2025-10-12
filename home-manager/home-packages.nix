{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop apps
    imv
    kdePackages.kdenlive
    mpv
    nautilus
    nmgui
    obs-studio
    pavucontrol
    thunderbird-latest

    # CLI utils
    bc
    bottom
    brightnessctl
    cliphist
    dnsutils
    fastfetch
    fd
    ffmpeg
    fzf
    git-graph
    grimblast
    htop
    httpie
    hyprpicker
    jq
    mediainfo
    ntfs3g
    playerctl
    ripgrep
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
    kdePackages.xwaylandvideobridge
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
