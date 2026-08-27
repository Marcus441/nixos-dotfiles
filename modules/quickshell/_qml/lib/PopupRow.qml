import QtQuick
import qs

Rectangle {
    id: root

    signal clicked

    property bool hoverable: true
    default property alias content: inner.data

    width: parent ? parent.width : implicitWidth
    implicitWidth: inner.implicitWidth + Theme.pad * 2
    implicitHeight: inner.implicitHeight + 12
    color: root.hoverable && mouse.containsMouse ? Config.base02 : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.durFast
        }
    }

    Row {
        id: inner

        anchors.left: parent.left
        anchors.leftMargin: Theme.pad
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.gap
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        enabled: root.hoverable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
