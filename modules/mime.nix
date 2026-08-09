_: {
  flake.modules.homeManager.core = [
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
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

          "application/acrobat" = "org.pwmt.zathura.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
          "application/vnd.pdf" = "org.pwmt.zathura.desktop";
          "application/x-pdf" = "org.pwmt.zathura.desktop";
          "text/pdf" = "org.pwmt.zathura.desktop";
          "text/x-pdf" = "org.pwmt.zathura.desktop";

          "image/gif" = "mpv.desktop";
          "image/jpeg" = "imv.desktop";
          "image/png" = "imv.desktop";
          "image/svg+xml" = "imv.desktop";
          "image/tiff" = "imv.desktop";
          "image/webp" = "imv.desktop";

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

          "audio/flac" = "mpv.desktop";
          "audio/mpeg" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "audio/wav" = "mpv.desktop";
          "audio/x-m4a" = "mpv.desktop";

          "application/json" = "nvim.desktop";
          "application/toml" = "nvim.desktop";
          "application/x-shellscript" = "nvim.desktop";
          "application/x-yaml" = "nvim.desktop";
          "application/x-zerosize" = "nvim.desktop";
          "text/plain" = "nvim.desktop";
          "text/x-python" = "nvim.desktop";
          "text/x-script.python" = "nvim.desktop";
          "text/x-shellscript" = "nvim.desktop";

          "x-scheme-handler/terminal" = "footclient.desktop";
        };
      };
    }
  ];
}
