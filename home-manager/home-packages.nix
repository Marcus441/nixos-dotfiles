{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically
    # Zsh
    zoxide

    # Desktop apps
    anki
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
    w3m
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip

    # WM stuff
    libsForQt5.xwaylandvideobridge
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
