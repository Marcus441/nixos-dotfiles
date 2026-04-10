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

    # CLI utils
    bc
    brightnessctl
    cliphist
    dnsutils
    ffmpeg
    grimblast
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
    mediainfo
    nmap
    pavucontrol
    playerctl
    silicon
    unzip
    wl-clipboard
    wtype
    yt-dlp
    zip

    # Other
    bemoji
    nix-prefetch-scripts
  ];
}
