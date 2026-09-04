import QtQuick
import qs

Rectangle {
    id: root

    signal clicked

    property bool hoverable: true
    readonly property alias hovered: mouse.containsMouse
    default property alias content: inner.data
    property alias trailing: trail.data

    width: parent ? parent.width : implicitWidth
    implicitWidth: inner.implicitWidth + trail.implicitWidth + Theme.pad * 2 + (trail.implicitWidth > 0 ? Theme.gap : 0)
    implicitHeight: Math.max(inner.implicitHeight, trail.implicitHeight) + 12
    color: root.hoverable && mouse.containsMouse ? Config.selection : "transparent"

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

    Row {
        id: trail

        anchors.right: parent.right
        anchors.rightMargin: Theme.pad
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
