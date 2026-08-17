pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root

    property string icon: ""
    property string temp: ""
    property string desc: ""

    function wmoIcon(code) {
        if (code === 0)
            return ["󰖨", "Clear"];
        if (code <= 2)
            return ["󰖕", "Partly cloudy"];
        if (code === 3)
            return ["󰖐", "Overcast"];
        if (code <= 49)
            return ["󰖑", "Foggy"];
        if (code <= 59)
            return ["󰖗", "Drizzle"];
        if (code <= 69)
            return ["󰖖", "Rain"];
        if (code <= 79)
            return ["󰖘", "Snow"];
        if (code <= 84)
            return ["󰖖", "Rain showers"];
        if (code <= 94)
            return ["󰖓", "Thunderstorm"];
        return ["󰨹", "N/A"];
    }

    Process {
        id: weatherProc

        command: [Config.curl, "-sS", "--fail", "--connect-timeout", "3", "--max-time", "6", `https://api.open-meteo.com/v1/forecast?latitude=${Config.weatherLat}&longitude=${Config.weatherLon}&current=temperature_2m,weathercode&timezone=${encodeURIComponent(Config.weatherTimezone)}`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const current = JSON.parse(text).current;
                    const icon = root.wmoIcon(current.weathercode);
                    root.icon = icon[0];
                    root.desc = icon[1];
                    root.temp = `${Math.round(current.temperature_2m)}°C`;
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProc.running = true
    }
}
