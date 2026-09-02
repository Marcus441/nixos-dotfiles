import QtQuick
import qs

Rectangle {
    id: root

    property real value: 0
    property color fill: Config.base0D

    height: 6
    radius: 3
    color: Config.base02

    Rectangle {
        width: root.width * Math.max(0, Math.min(root.value, 1))
        height: parent.height
        radius: 3
        color: root.fill

        Behavior on width {
            NumberAnimation {
                duration: Theme.durMed
            }
        }
    }
}
