{
  xdg.configFile = {
    "waybar/scripts/weather.sh".text = ''
      #!/usr/bin/env bash
      # Brisbane coords
      LAT="-27.4705"
      LON="153.0260"

      data=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weathercode,windspeed_10m,relativehumidity_2m&timezone=Australia%2FBrisbane")

      if [[ -z "$data" || "$data" == *"error"* ]]; then
        exit 0
      fi

      temp=$(echo "$data" | jq '.current.temperature_2m')
      code=$(echo "$data" | jq '.current.weathercode')
      wind=$(echo "$data" | jq '.current.windspeed_10m')
      humidity=$(echo "$data" | jq '.current.relativehumidity_2m')

      # WMO weathercode to icon
      if   [[ $code -eq 0 ]];                    then icon="󰖙"  desc="Clear"
      elif [[ $code -le 2 ]];                    then icon="󰖕"  desc="Partly cloudy"
      elif [[ $code -eq 3 ]];                    then icon="󰖐"  desc="Overcast"
      elif [[ $code -le 49 ]];                   then icon="󰖑"  desc="Foggy"
      elif [[ $code -le 59 ]];                   then icon="󰖗"  desc="Drizzle"
      elif [[ $code -le 69 ]];                   then icon="󰖖"  desc="Rain"
      elif [[ $code -le 79 ]];                   then icon="󰖘"  desc="Snow"
      elif [[ $code -le 84 ]];                   then icon="󰖖"  desc="Rain showers"
      elif [[ $code -le 94 ]];                   then icon="󰖓"  desc="Thunderstorm"
      else                                            icon=""  desc="N/A"
      fi

      text="$icon  ''${temp}°C"
      tooltip="$desc\n ''${temp}°C 󰖝 ''${wind}km/h  ''${humidity}%"

      echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"weather\"}"
    '';
    "waybar/scripts/weather.sh".executable = true;
  };
}
