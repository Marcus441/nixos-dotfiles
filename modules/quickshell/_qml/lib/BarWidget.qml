import QtQuick
import qs

Text {
    id: root

    signal clicked
    signal rightClicked
    signal scrolled(int delta)

    property color baseColor: Config.textMuted
    property bool hover: mouse.containsMouse

    color: baseColor
    font.family: Config.iconFamily
    font.pixelSize: Config.fontSize
    verticalAlignment: Text.AlignVCenter

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
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouseEvent => {
            if (mouseEvent.button === Qt.RightButton)
                root.rightClicked();
            else
                root.clicked();
        }
        onWheel: wheelEvent => root.scrolled(wheelEvent.angleDelta.y)
    }
}
