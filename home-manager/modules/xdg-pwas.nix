{pkgs, ...}: let
  apps = [
    {
      id = "chatgpt";
      name = "ChatGPT";
      url = "https://chatgpt.com/";
      iconUrl = "https://img.icons8.com/?size=100&id=FBO05Dys9QCg&format=png&color=FFFFFF";
      iconSha = "sha256-/5movXxtZ/lhkfgxwQTHZYHYMtZjIW9LgXpsR4TCCP0=";
      categories = ["Network" "Chat"];
      wmClass = "ChatGPT";
    }
  ];
in {
  xdg.desktopEntries = builtins.listToAttrs (map (app: {
      name = app.id;
      value = {
        inherit (app) name;
        exec = "chromium --app=${app.url}";
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
