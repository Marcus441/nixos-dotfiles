{
  xdg.configFile = {
    "waybar/scripts/powerdraw.sh".text = ''
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
    "waybar/scripts/powerdraw.sh".executable = true;

    "waybar/scripts/weather.sh".text = ''
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
    "waybar/scripts/weather.sh".executable = true;
  };
}
