{
  xdg.mimeApps = {
    enable = true;
    associations.removed = {
      "application/pdf" = "helium.desktop";
      "application/vnd.pdf" = "helium.desktop";
      "application/x-pdf" = "helium.desktop";
      "text/pdf" = "helium.desktop";
      "text/x-pdf" = "helium.desktop";
    };
    defaultApplications = {
      # File Browser
      "inode/directory" = "thunar.desktop";

      # Browser
      "application/x-extension-htm" = "helium.desktop";
      "application/x-extension-html" = "helium.desktop";
      "application/x-extension-shtml" = "helium.desktop";
      "application/x-extension-xht" = "helium.desktop";
      "application/x-extension-xhtml" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "text/html" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "x-scheme-handler/webcal" = "helium.desktop";

      # PDF
      "application/acrobat" = "zathura.desktop";
      "application/pdf" = "zathura.desktop";
      "application/vnd.pdf" = "zathura.desktop";
      "application/x-pdf" = "zathura.desktop";
      "text/pdf" = "zathura.desktop";
      "text/x-pdf" = "zathura.desktop";

      # Email
      "message/rfc822" = "thunderbird.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";

      # Discord
      "x-scheme-handler/discord" = "vesktop.desktop";

      # Images
      "image/gif" = "mpv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/webp" = "imv.desktop";

      # Video
      "application/x-matroska" = "mpv.desktop";
      "audio/matroska" = "mpv.desktop";
      "audio/x-matroska" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/matroska" = "mpv.desktop";
      "video/matroska-3d" = "mpv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/x-msvideo" = "mpv.desktop";

      # Audio
      "audio/flac" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/x-m4a" = "mpv.desktop";

      # Code/Text
      "application/json" = "neovide.desktop";
      "application/toml" = "neovide.desktop";
      "application/x-shellscript" = "neovide.desktop";
      "application/x-yaml" = "neovide.desktop";
      "application/x-zerosize" = "neovide.desktop";
      "text/plain" = "neovide.desktop";
      "text/x-python" = "neovide.desktop";
      "text/x-script.python" = "neovide.desktop";
      "text/x-shellscript" = "neovide.desktop";

      # Terminal
      "x-scheme-handler/terminal" = "ghostty.desktop";
    };
  };
}
