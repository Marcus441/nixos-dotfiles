import Quickshell
import QtQuick
import qs
import qs.services

Grid {
    id: root

    property bool vertical: false

    columns: vertical ? 1 : 2
    spacing: Theme.gap
    horizontalItemAlignment: Grid.AlignHCenter
    verticalItemAlignment: Grid.AlignVCenter

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Text {
        visible: Weather.icon !== ""
        text: root.vertical ? `${Weather.icon}\n${Weather.temp.replace("C", "")}` : `${Weather.icon} ${Weather.temp}`
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
