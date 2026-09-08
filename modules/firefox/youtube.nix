_: let
  shorts = "https://raw.githubusercontent.com/gijsdev/ublock-hide-yt-shorts/master/list.txt";
in {
  flake.modules.homeManager.firefox = [
    {
      programs.firefox.policies = {
        ExtensionSettings = {
          "deArrow@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
          };

          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          };
        };

        "3rdparty".Extensions."uBlock0@raymondhill.net".adminSettings = {
          selectedFilterLists = [shorts];

          # load-bearing: docs/decisions/firefox.md#ubo-imported-lists
          userSettings.importedLists = [shorts];

          userFilters = ''
            www.youtube.com##ytd-browse[page-subtype="home"] ytd-rich-grid-renderer
            www.youtube.com##ytd-watch-next-secondary-results-renderer
            www.youtube.com###comments
            www.youtube.com##.ytp-ce-element
            www.youtube.com##.ytp-endscreen-content
            www.youtube.com##.ytp-autonav-endscreen-upnext-container
          '';
        };
      };
    }
  ];
}
