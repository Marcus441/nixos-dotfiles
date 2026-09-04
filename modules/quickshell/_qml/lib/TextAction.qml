import QtQuick
import qs

Text {
    id: root

    signal triggered

    property bool toggled: false

    color: root.toggled ? Config.accent : mouse.containsMouse ? Config.textPrimary : Config.textSecondary
    font.family: Config.iconFamily
    font.pixelSize: Config.fontSize

    Behavior on color {
        ColorAnimation {
            duration: Theme.durFast
        }
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
