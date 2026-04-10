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

    # Tmux utilities
    (writeShellScriptBin "tmux-switch" ''
      tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" | \
        fzf-tmux -p 60%,40% --prompt="switch  " --border rounded | \
        awk '{print $1}' | \
        xargs -I{} tmux switch-client -t {}
    '')
    (writeShellScriptBin "tmux-kill" ''
      target=$(echo -e "pane\nwindow\nsession" | fzf-tmux -p 40%,30% --prompt="kill  " --border rounded)
      case "$target" in
        pane)
          tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command}" | \
            fzf-tmux -p 60%,40% --prompt="kill pane  " | \
            awk '{print $1}' | \
            xargs -I{} tmux kill-pane -t {}
          ;;
        window)
          tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name}" | \
            fzf-tmux -p 60%,40% --prompt="kill window  " | \
            awk '{print $1}' | \
            xargs -I{} tmux kill-window -t {}
          ;;
        session)
          tmux list-sessions -F "#{session_name}" | \
            fzf-tmux -p 50%,35% --prompt="kill session  " | \
            xargs -I{} tmux kill-session -t {}
          ;;
      esac
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
