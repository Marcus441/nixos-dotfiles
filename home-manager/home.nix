{
  homeStateVersion,
  user,
  pkgs,
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
      ".config/rofi/image".source = pkgs.runCommand "rofi-wallpaper" {buildInputs = [pkgs.imagemagick];} ''
        mkdir -p $out
        cp ${pkgs.fetchurl {
          url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-blue.png";
          hash = "sha256-+jfTuvl1VJocN+YNp04YVONR054GX+p/yxNXyyhsNcs=";
        }} source.png

        magick source.png \
          -strip \
          -fuzz 2% \
          -fill "#282727" -opaque "#272727" \
          -fill "#8EA4A2" -opaque "#81A695" \
          -fill "#8992A7" -opaque "#458587" \
          -crop 2560x2560+2560+880 \
          -resize 1024x1024 \
          $out/image.jpg
      '';
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
