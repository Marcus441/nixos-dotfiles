import QtQuick
import qs

Rectangle {
    id: root

    signal clicked

    property bool hoverable: true
    default property alias content: inner.data

    width: parent ? parent.width : implicitWidth
    implicitWidth: inner.implicitWidth + 28
    implicitHeight: inner.implicitHeight + 12
    color: root.hoverable && mouse.containsMouse ? Config.base02 : "transparent"

    Row {
        id: inner

        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
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
