{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # File Browser
      "inode/directory" = "thunar.desktop";

      # Browser
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/webcal" = "firefox.desktop";

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
      "application/json" = "neovim.desktop";
      "application/toml" = "neovim.desktop";
      "application/x-shellscript" = "neovim.desktop";
      "application/x-yaml" = "neovim.desktop";
      "application/x-zerosize" = "neovim.desktop";
      "text/plain" = "neovim.desktop";
      "text/x-python" = "neovim.desktop";
      "text/x-script.python" = "neovim.desktop";
      "text/x-shellscript" = "neovim.desktop";

      # Terminal
      "x-scheme-handler/terminal" = "ghostty.desktop";
    };
  };
}
