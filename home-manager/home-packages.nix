{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically
    # Zsh
    zoxide

    # Desktop apps
    firefox
    imv
    mpv
    obs-studio
    pavucontrol
    teams-for-linux
    thunderbird
    xfce.thunar
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
    ffmpegthumbnailer
    fzf
    git-graph
    grimblast
    htop
    httpie
    hyprpicker
    ntfs3g
    neovim
    mediainfo
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
