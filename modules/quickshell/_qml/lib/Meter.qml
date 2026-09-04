import QtQuick
import qs

Rectangle {
    id: root

    signal moved(real fraction)
    signal released
    signal canceled

    property real value: 0
    property color fill: Config.accent
    property bool interactive: false

    readonly property real fraction: Math.max(0, Math.min(root.value, 1))

    height: 6
    radius: 3
    color: Config.selection

    Rectangle {
        width: root.fraction === 0 ? 0 : Math.max(root.height, root.width * root.fraction)
        height: parent.height
        radius: 3
        color: root.fill

        Behavior on width {
            enabled: !dragArea.pressed

            NumberAnimation {
                duration: Theme.durMed
            }
        }
    }

    MouseArea {
        id: dragArea

        anchors.fill: parent
        anchors.topMargin: -4
        anchors.bottomMargin: -4
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
        onPressed: mouseEvent => root.moved(mouseEvent.x / root.width)
        onPositionChanged: mouseEvent => {
            if (pressed)
                root.moved(mouseEvent.x / root.width);
        }
        onReleased: root.released()
        onCanceled: root.canceled()
    }
}
