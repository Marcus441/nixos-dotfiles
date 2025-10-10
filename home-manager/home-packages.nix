{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    imv
    kdePackages.kdenlive
    mpv
    nautilus
    networkmanager_dmenu
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
    neovim
    ntfs3g
    playerctl
    ripgrep
    silicon
    tree
    udisks
    ueberzugpp
    unzip
    usbutils
    w3m
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
