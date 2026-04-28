{config, ...}: {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      AIControls = {
        Default = {
          Value = "blocked";
          Locked = true;
        };
      };
      DisablePocket = true;
      DisableFormHistory = true;
      NoDefaultBookmarks = true;
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          settings = {
            selectedFilterLists = [
              # uBlock defaults
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-unbreak"
              "ublock-quick-fixes"

              "privacy-tracking"
              "urlhaus-1"
              "ublock-annoyances"
            ];
          };
        };

        # SponsorBlock
        "sponsorBlocker@ajay.app" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          settings = {
            # "skip", "mute-segment", "full", or "ignore" per category
            segmentSeverity = {
              sponsor = "skip";
              selfpromo = "skip";
              interaction = "skip";
              intro = "skip";
              outro = "skip";
              preview = "skip";
              music_offtopic = "skip";
              filler = "ignore";
              poi_highlight = "ignore";
            };
          };
        };

        # Unhook
        "myallychou@gmail.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
        };

        # Refined GitHub
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        };

        # File Icon for GitHub, GitLab and Bitbucket
        "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/github-file-icons/latest.xpi";
        };

        # Kagi
        "search@kagi.com" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
        };

        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };

        # Dark Reader
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
      };
    };

    profiles.default = {
      id = 0;
      isDefault = true;

      # ── Search ───────────────────────────────────────────────
      search = {
        force = true;
        default = "Kagi";
        engines = {
          "Kagi" = {
            name = "Kagi";
            urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
            definedAliases = ["@k"];
          };
          "claude" = {
            name = "Claude";
            urls = [{template = "https://claude.ai/new?q={searchTerms}";}];
            definedAliases = ["@claude"];
          };
          "nix-packages" = {
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
            definedAliases = ["@np"];
          };
          "nix-options" = {
            name = "NixOS Options";
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@no"];
          };
          "nix-wiki" = {
            name = "NixOS Wiki";
            urls = [
              {
                template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
              }
            ];
            definedAliases = ["@nw"];
          };
          "home-manager" = {
            name = "Home Manager Options";
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            definedAliases = ["@hm"];
          };
          # Hide everything else
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "amazon".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "ddg".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      # ── Settings ─────────────────────────────────────────────
      settings = {
        "general.autoScroll" = true;
        # Wayland / Hyprland
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # GPU / Rendering
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "layers.acceleration.force-enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;

        # Font rendering
        "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
        "gfx.font_rendering.opentype_svg.enabled" = false;
        "font.name-list.emoji" = "emoji";

        # Smooth scrolling — MSD physics (Chromium-like feel)
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = 1.3;
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "mousewheel.default.delta_multiplier_y" = 100;
        "apz.gtk.kinetic_scroll.enabled" = false;

        # Memory / Cache
        "browser.cache.memory.capacity" = 524288; # 512 MB
        "browser.cache.memory.enable" = true;
        "browser.cache.disk.enable" = true;
        "dom.ipc.processCount" = 8; # lower to 4 on 8 GB RAM
        "dom.ipc.processCount.webIsolated" = 4;

        # Network performance
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        "network.http.pipelining" = true;
        "network.http.pipelining.maxrequests" = 8;
        "network.http.http3.enabled" = true;
        "network.http.speculative-parallel-limit" = 10;
        "network.predictor.enabled" = true;
        "network.predictor.enable-prefetch" = true;
        "network.prefetch-next" = true;
        "network.dns.disablePrefetch" = false;

        # Startup / UI
        "browser.startup.page" = 3;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.startup.preXulSkeletonUI" = false;
        "ui.prefersReducedMotion" = 0;

        # Auto-enable extensions without approval prompt
        "extensions.autoDisableScopes" = 0;

        # Misc
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.useDownloadDir" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "full-screen-api.warning.timeout" = 0;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      };
    };
  };
}
