{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop apps
    imv
    kdePackages.kdenlive
    mpv
    obs-studio

    # Document & Image Rendering (For Neovim/Snacks)
    ghostscript
    tectonic

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
    (writeShellScriptBin "ocr-copy" ''
      export PATH=$PATH:${lib.makeBinPath [grimblast tesseract wl-clipboard libnotify]}

      text=$(grimblast --freeze save area - | tesseract stdin stdout --psm 6)

      if [ -n "$text" ]; then
          echo "$text" | wl-copy
          notify-send "OCR Successful" "Text copied to clipboard"
      else
          notify-send "OCR Failed" "No text detected"
      fi
    '')
    hyprpicker
    imagemagick
    jq
    mediainfo
    nmap
    ntfs3g
    pavucontrol
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
