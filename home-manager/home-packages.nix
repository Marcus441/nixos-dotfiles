{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically
    # Zsh
    zoxide

    # Desktop apps
    anki
    code-cursor
    floorp
    imv
    mpv
    obs-studio
    pavucontrol
    teams-for-linux
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
    hyprpicker
    ntfs3g
    neovim
    mediainfo
    playerctl
    ripgrep
    showmethekey
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

    # Lua
    lua

    # Rust
    rustc
    cargo

    # Javascript
    nodejs_23

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}
