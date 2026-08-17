import QtQuick
import qs

Text {
    id: root

    signal triggered

    property bool active: mouse.containsMouse

    color: active ? Config.base0D : Config.base04
    font.family: Config.iconFamily
    font.pixelSize: Config.fontSize

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
