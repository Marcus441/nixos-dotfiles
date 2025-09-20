{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Desktop apps
    firefox
    imv
    mpv
    obs-studio
    kdePackages.kdenlive
    pavucontrol
    thunderbird
    xfce.thunar
    networkmanager_dmenu
    vesktop

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
    ntfs3g
    neovim
    mediainfo
    tree
    playerctl
    ripgrep
    silicon
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
