{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Browser
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "x-scheme-handler/webcal" = "helium.desktop";
      "application/x-extension-htm" = "helium.desktop";
      "application/x-extension-html" = "helium.desktop";
      "application/x-extension-shtml" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
      "application/x-extension-xhtml" = "helium.desktop";
      "application/x-extension-xht" = "helium.desktop";

      # PDF
      "application/pdf" = "zathura.desktop";
      "application/x-pdf" = "zathura.desktop";
      "application/acrobat" = "zathura.desktop";
      "application/vnd.pdf" = "zathura.desktop";
      "text/pdf" = "zathura.desktop";
      "text/x-pdf" = "zathura.desktop";

      # Email
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/mid" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";

      # Discord
      "x-scheme-handler/discord" = "vesktop.desktop";

      # Images
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/tiff" = "imv.desktop";

      # Video
      "video/mp4" = "mpv.desktop";
      "video/mkv" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/avi" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/x-m4a" = "mpv.desktop";

      # Code/Text
      "text/plain" = "neovide.desktop";
      "application/json" = "neovide.desktop";
      "application/x-yaml" = "neovide.desktop";
      "application/toml" = "neovide.desktop";
      "application/x-zerosize" = "neovide.desktop";

      # Terminal
      "x-scheme-handler/terminal" = "ghostty.desktop";
    };
  };
}
