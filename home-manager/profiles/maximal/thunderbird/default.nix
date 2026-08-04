{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./style.nix
  ];

  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.default = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "mail.spellcheck.inline" = true;
        "network.protocol-handler.warn-external.http" = true;
        "network.protocol-handler.warn-external.https" = true;
        "extensions.autoDisableScopes" = 0;
        "font.name.sans-serif.x-western" = "Inter";
        "font.size.variable.x-western" = 16;

        "mailnews.default_view_flags" = 64;
        "mailnews.default_sort_type" = 18;
        "mailnews.default_sort_order" = 2;

        "mail.tabs.drawInTitlebar" = false;
        "ui.systemUsesDarkTheme" = 1;
        "widget.gtk.theme-variant" = "dark";
        "widget.wayland.opaque-region" = true;

        "gfx.webrender.all" = true;
        "layers.acceleration.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "network.http.http3.enable" = true;
        "image.mem.decode_ondemand" = true;
      };
    };
  };
}
