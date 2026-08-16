import Quickshell
import Quickshell.Io
import QtQuick
import qs

Grid {
    id: root

    property bool vertical: false
    property string weatherIcon: ""
    property string weatherTemp: ""
    property string weatherDesc: ""

    columns: vertical ? 1 : 2
    spacing: 8
    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

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

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Process {
        id: weatherProc

        command: [Config.curl, "-sS", "--fail", "--connect-timeout", "3", "--max-time", "6", `https://api.open-meteo.com/v1/forecast?latitude=${Config.weatherLat}&longitude=${Config.weatherLon}&current=temperature_2m,weathercode&timezone=${encodeURIComponent(Config.weatherTimezone)}`]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const current = JSON.parse(text).current;
                    const icon = root.wmoIcon(current.weathercode);
                    root.weatherIcon = icon[0];
                    root.weatherDesc = icon[1];
                    root.weatherTemp = `${Math.round(current.temperature_2m)}°C`;
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

    Text {
        visible: root.weatherIcon !== ""
        text: root.vertical ? `${root.weatherIcon}\n${root.weatherTemp.replace("C", "")}` : `${root.weatherIcon} ${root.weatherTemp}`
        color: Config.base05
        font.family: Config.iconFamily
        font.pixelSize: Config.fontSize
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        text: root.vertical ? Qt.formatDateTime(clock.date, "HH\nmm") : Qt.formatDateTime(clock.date, "dddd HH:mm")
        color: Config.base05
        font.family: Config.fontFamily
        font.pixelSize: Config.fontSize
        horizontalAlignment: Text.AlignHCenter
    }
}
