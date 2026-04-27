{
  pkgs,
  lib,
  ...
}: {
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

    # Archive
    unzip
    zip

    # Other
    bemoji
    nix-prefetch-scripts
    silicon
  ];
}
