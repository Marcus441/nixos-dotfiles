{config, ...}: {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFormHistory = true;

      AIControls = {
        Default = {
          Value = "blocked";
          Locked = true;
        };
      };

      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;

      NoDefaultBookmarks = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisableFeedbackCommands = true;

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        Locked = true;
      };

      Permissions = {
        Notifications = {
          BlockNewRequests = true;
          Locked = false;
        };
      };

      # ── DNS-over-HTTPS ───────────────────────────────────────
      # Left OFF by default: on NixOS you very likely run a local or
      # split-horizon resolver (systemd-resolved, dnscrypt, .local mDNS,
      # VPN DNS), and forcing DoH here would bypass it. If you DON'T,
      # uncomment to encrypt DNS against your ISP. Mullvad = no logs.
      #
      # DNSOverHTTPS = {
      #   Enabled = true;
      #   ProviderURL = "https://dns.mullvad.net/dns-query";
      #   Fallback = true;      # fall back to system DNS if DoH fails
      #   Locked = false;
      # };

      ExtensionSettings = {
        # Australian English Dictionary
        "AussieDic@dictionaries.addons.mozilla.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/australian-english-dictionary/latest.xpi";
        };
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

      userChrome = ''
        #firefox-view-button { display: none !important; }
      '';

      settings = {
        "intl.accept_languages" = "en-AU, en";
        "spellchecker.dictionary" = "en-AU";

        "browser.contentblocking.category" = "strict";

        "privacy.fingerprintingProtection" = true;

        "privacy.query_stripping.enabled" = true;
        "privacy.query_stripping.enabled.pbmode" = true;

        "network.http.referer.XOriginTrimmingPolicy" = 2;

        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        "media.peerconnection.ice.default_address_only" = true;

        "browser.safebrowsing.downloads.remote.enabled" = false;

        "browser.send_pings" = false;
        "beacon.enabled" = false;

        "network.IDN_show_punycode" = true;

        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "network.prefetch-next" = false;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;
        "network.http.speculative-parallel-limit" = 0;
        "browser.urlbar.speculativeConnect.enabled" = false;

        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.suggest.trending" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;

        "browser.region.update.enabled" = false;
        "browser.region.network.url" = "";

        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;

        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.discovery.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;

        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        "widget.use-xdg-desktop-portal.file-picker" = 2;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;

        "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
        "gfx.font_rendering.opentype_svg.enabled" = false;
        "font.name-list.emoji" = "emoji";

        "general.autoScroll" = true;
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
        "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = 1.3;
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
        "apz.gtk.kinetic_scroll.enabled" = false;

        "browser.cache.memory.capacity" = -1;
        "browser.cache.memory.enable" = true;
        "browser.cache.disk.enable" = true;

        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.max-urgent-start-excessive-connections-per-host" = 5;
        "network.http.http3.enabled" = true;

        "browser.startup.page" = 3;
        "browser.startup.homepage" = "about:blank";
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.startup.preXulSkeletonUI" = false;
        "ui.prefersReducedMotion" = 0;

        "extensions.autoDisableScopes" = 0;

        # ── UI density & chrome ──────────────────────────────
        "browser.uidensity" = 1;
        "browser.compactmode.show" = true;
        "browser.toolbars.bookmarks.visibility" = "newtab";
        "browser.tabs.firefox-view" = false;

        # ── Tabs ─────────────────────────────────────────────
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "browser.tabs.loadBookmarksInTabs" = true;
        "browser.tabs.closeTabByDblclick" = true;

        # ── URL bar & find ───────────────────────────────────
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "findbar.highlightAll" = true;

        # ── Annoyance fixes ──────────────────────────────────
        "browser.download.alwaysOpenPanel" = false;
        "browser.translations.automaticallyPopup" = false;
        "cookiebanners.service.mode" = 2;
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "middlemouse.paste" = false;
        "full-screen-api.transition-duration.enter" = "0 0";
        "full-screen-api.transition-duration.leave" = "0 0";
        "full-screen-api.warning.delay" = -1;

        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.download.useDownloadDir" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "full-screen-api.warning.timeout" = 0;
      };
    };
  };
}
