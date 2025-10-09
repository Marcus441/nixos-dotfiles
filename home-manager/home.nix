{
  homeStateVersion,
  pkgs,
  user,
  ...
}: {
  imports = [
    ./modules
    ./home-packages.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    shell.enableFishIntegration = true;

    # custom weather and power draw script for waybar
    file = {
      ".config/waybar/scripts/powerdraw.sh".text = ''
        #!/usr/bin/env bash
        for bat in /sys/class/power_supply/BAT*/power_now; do
          if [ -f "$bat" ]; then
            powerDraw="󰠰  $(($(cat "$bat") / 1000000))w"
            break
          fi
        done
        cat << EOF
        { "text":"$powerDraw", "tooltip":"Power Draw: $powerDraw" }
        EOF
      '';
      ".config/waybar/scripts/powerdraw.sh".executable = true;

      ".config/waybar/scripts/weather.sh".text = ''
        #!/usr/bin/env bash

        LOC=""

        text="$(curl -s "https://wttr.in/$LOC?format=1" | tr -d ' ')"
        tooltip="$(curl -s "https://wttr.in/$LOC?0QT" |
            sed 's/\\/\\\\/g' |
            sed ':a;N;$!ba;s/\n/\\n/g' |
            sed 's/"/\\"/g')"

        if ! grep -q "Unknown location" <<< "$text"; then
            echo "{\"text\": \"$text\", \"tooltip\": \"<tt>$tooltip</tt>\", \"class\": \"weather\"}"
        fi
      '';
      ".config/waybar/scripts/weather.sh".executable = true;
      ".local/share/applications/chatgpt.desktop".text = ''
        [Desktop Entry]
        Name=ChatGPT
        Exec=${pkgs.chromium}/bin/chromium --app=https://chatgpt.com/
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=FBO05Dys9QCg&format=png&color=FFFFFF";
          sha256 = "sha256-/5movXxtZ/lhkfgxwQTHZYHYMtZjIW9LgXpsR4TCCP0=";
        }}
        Type=Application
        StartupWMClass=ChatGPT
        Categories=Network;Chat;
        Terminal=false
      '';
      ".local/share/applications/teams.desktop".text = ''
        [Desktop Entry]
        Name=Teams
        Exec=${pkgs.chromium}/bin/chromium --app=https://teams.microsoft.com
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=zQ92KI7XjZgR&format=png&color=000000";
          sha256 = "sha256-kD4vRyTMKgKjNDxhQGu/ESIIf31ZjntDfhtEUmofeTU=";
        }}
        Type=Application
        StartupWMClass=Microsoft Teams
        Categories=Network;Chat;
        Terminal=false
      '';
      ".local/share/applications/github.desktop".text = ''
        [Desktop Entry]
        Name=GitHub
        Exec=${pkgs.chromium}/bin/chromium --app=https://github.com/
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=12599&format=png&color=FFFFFF";
          sha256 = "sha256-qpDgoyvAfEl7weF5j4ctu6EqDZ02mFvB13vWvObdTYY=";
        }}
        Type=Application
        StartupWMClass=GitHub
        Categories=Development;Network;
        Terminal=false
      '';
      ".local/share/applications/youtubemusic.desktop".text = ''
        [Desktop Entry]
        Name=YouTube Music
        Exec=${pkgs.chromium}/bin/chromium --app=https://music.youtube.com/
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=V1cbDThDpbRc&format=png&color=000000";
          sha256 = "sha256-xLLaOiDYQxpEiyknyNnt5wYrthHTeVMJmb6HrpaBhZM=";
        }}
        Type=Application
        StartupWMClass=YouTube Music
        Categories=AudioVideo;Music;Player;
        Terminal=false
      '';

      ".local/share/applications/googlecalendar.desktop".text = ''
        [Desktop Entry]
        Name=Google Calendar
        Exec=${pkgs.chromium}/bin/chromium --app=https://calendar.google.com/
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=WKF3bm1munsk&format=png&color=000000";
          sha256 = "sha256-KwMlADIJS7pV3t2Hpi3YA5YEcofdIztbvs4sjPPtAho=";
        }}
        Type=Application
        StartupWMClass=Google Calendar
        Categories=Office;Calendar;
        Terminal=false
      '';

      ".local/share/applications/messenger.desktop".text = ''
        [Desktop Entry]
        Name=Messenger
        Exec=${pkgs.chromium}/bin/chromium --app=https://www.messenger.com/
        Icon=${pkgs.fetchurl {
          url = "https://img.icons8.com/?size=100&id=YFbzdUk7Q3F8&format=png&color=000000";
          sha256 = "sha256-4nwEBdecinsSTDkZwQB7R1KIIV8GOSj8kGbzAcXdkTA=";
        }}
        Type=Application
        StartupWMClass=Messenger
        Categories=Network;Chat;
        Terminal=false
      '';
    };
  };
}
