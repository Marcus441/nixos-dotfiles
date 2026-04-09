{pkgs, ...}: let
  apps = [
    {
      id = "claude";
      name = "Claude";
      url = "https://claude.ai/";
      iconUrl = "https://img.icons8.com/?size=100&id=zQjzFjPpT2Ek&format=png&color=000000";
      iconSha = "sha256-aPWuiB7uaXLBLNEdv42g/tVilPmWLKP88jAbTaOeTWM=";
      categories = ["Network" "Chat"];
      wmClass = "Claude";
    }
  ];
in {
  xdg.desktopEntries = builtins.listToAttrs (map (app: {
      name = app.id;
      value = {
        inherit (app) name;
        exec = "helium --app=${app.url}";
        icon = pkgs.fetchurl {
          url = app.iconUrl;
          sha256 = app.iconSha;
        };
        inherit (app) categories;
        terminal = false;
        startupNotify = false;
        settings = {StartupWMClass = app.wmClass;};
      };
    })
    apps);
}
