{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
    inputs.nur.modules.homeManager.default
  ];

  programs.zen-browser = {
    enable = true;

    policies = let
      mkLockedAttrs = builtins.mapAttrs (_: value: {
        Value = value;
        Status = "locked";
      });
    in {
      Preferences = mkLockedAttrs {
        "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
        "gfx.webrender.quality.force-text-aa-level" = 2;
        "gfx.font_rendering.cleartype_params.gamma" = 2200;
        "gfx.font_rendering.cleartype_params.enhanced_contrast" = 150;
        "gfx.font_rendering.cleartype_params.pixel_structure" = 1;
        "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
        "gfx.webrender.all" = true;
        "browser.cache.disk.enable" = false;
        "browser.sessionstore.interval" = 600000;
        "layout.css.dpi" = 0;
        "browser.display.os-zoom-behavior" = 0;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "mousewheel.min_line_scroll_amount" = 30;
        "browser.quitShortcut.disabled" = true;
        "browser.download.alwaysOpenPanel" = false;
      };

      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles."user" = {
      isDefault = true;

      # Extensions (from NUR Firefox Addons)
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          adnauseam
          bitwarden
          darkreader
          sponsorblock
          vimium
        ];
      };

      # Search engines
      search = {
        default = "google-classic";
        engines = {
          nix-packages = {
            name = "Nix Packages";
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };

          nixos-wiki = {
            name = "NixOS Wiki";
            urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
            iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
            definedAliases = ["@nw"];
          };

          google-classic = {
            name = "Google (Classic)";
            urls = [{template = "https://www.google.com/search?q={searchTerms}&udm=14";}];
            icon = "https://www.google.com/favicon.ico";
          };

          bing = {
            metaData.hidden = true;
          };

          google = {
            metaData.alias = "@g";
          };
        };
        force = true;
      };
    };
  };
}
