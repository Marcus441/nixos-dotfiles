{
  homeStateVersion,
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

    # custom weather and power draw script for waybar
    file = {
      ".config/waybar/scripts/powerdraw.sh".text = ''
        #!/usr/bin/env bash
        for bat in /sys/class/power_supply/BAT*/power_now; do
          if [ -f "$bat" ]; then
            powerDraw="󰠰 $(($(cat "$bat") / 1000000))w"
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
        BSSIDS="$(nmcli device wifi list |
            awk 'NR>1 {if ($1 != "*") {print $1}}' |
            tr -d ":" |
            tr "\n" ",")"

        LOC=""
        REQUEST_GEO="$(wget -qO - "http://openwifi.su/api/v1/bssids/$BSSIDS")"

        if [[ "$(jq ".count_results" <<< "$REQUEST_GEO")" -gt 0 ]]; then
            LAT="$(jq ".lat" <<< "$REQUEST_GEO")"
            LON="$(jq ".lon" <<< "$REQUEST_GEO")"
            LOC="$LAT,$LON"
        fi

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
    };
  };
}
