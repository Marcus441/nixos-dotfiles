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
    {
      id = "teams";
      name = "Microsoft Teams";
      url = "https://teams.microsoft.com";
      iconUrl = "https://img.icons8.com/?size=100&id=zQ92KI7XjZgR&format=png&color=000000";
      iconSha = "sha256-kD4vRyTMKgKjNDxhQGu/ESIIf31ZjntDfhtEUmofeTU=";
      categories = ["Network" "Chat"];
      wmClass = "Microsoft Teams";
    }
    {
      id = "github";
      name = "GitHub";
      url = "https://github.com/";
      iconUrl = "https://img.icons8.com/?size=100&id=12599&format=png&color=FFFFFF";
      iconSha = "sha256-qpDgoyvAfEl7weF5j4ctu6EqDZ02mFvB13vWvObdTYY=";
      categories = ["Development" "Network"];
      wmClass = "GitHub";
    }
    {
      id = "youtubemusic";
      name = "YouTube Music";
      url = "https://music.youtube.com/";
      iconUrl = "https://img.icons8.com/?size=100&id=V1cbDThDpbRc&format=png&color=000000";
      iconSha = "sha256-xLLaOiDYQxpEiyknyNnt5wYrthHTeVMJmb6HrpaBhZM=";
      categories = ["AudioVideo" "Music" "Player"];
      wmClass = "YouTube Music";
    }
    {
      id = "googlecalendar";
      name = "Google Calendar";
      url = "https://calendar.google.com/";
      iconUrl = "https://img.icons8.com/?size=100&id=WKF3bm1munsk&format=png&color=000000";
      iconSha = "sha256-KwMlADIJS7pV3t2Hpi3YA5YEcofdIztbvs4sjPPtAho=";
      categories = ["Office" "Calendar"];
      wmClass = "Google Calendar";
    }
    {
      id = "messenger";
      name = "Messenger";
      url = "https://www.messenger.com/";
      iconUrl = "https://img.icons8.com/?size=100&id=YFbzdUk7Q3F8&format=png&color=000000";
      iconSha = "sha256-4nwEBdecinsSTDkZwQB7R1KIIV8GOSj8kGbzAcXdkTA=";
      categories = ["Network" "Chat"];
      wmClass = "Messenger";
    }
    # {
    #   id = "discord";
    #   name = "Discord";
    #   url = "https://discord.com/channels/@me";
    #   iconUrl = "https://img.icons8.com/?size=100&id=30998&format=png&color=000000";
    #   iconSha = "sha256-zb3Es1izZAwProek4Wcc7g3ZKxoVzX4JMEqpYIjmLwY=";
    #   categories = ["Network" "Chat"];
    #   wmClass = "Discord";
    # }
  ];
in {
  xdg.desktopEntries = builtins.listToAttrs (map (app: {
      name = app.id;
      value = {
        inherit (app) name;
        exec = "${pkgs.chromium}/bin/chromium --app=${app.url}";
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
