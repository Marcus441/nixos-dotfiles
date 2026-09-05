import QtQuick
import qs

Item {
    id: root

    signal clicked

    property bool hoverable: true
    property int insetX: Theme.gap
    property int insetY: Theme.gap / 2
    property bool highlighted: false
    readonly property alias hovered: mouse.containsMouse
    default property alias content: inner.data
    property alias trailing: trail.data

    // the inset is drawn, not positioned: a ListView writes its delegate's x
    // and y during layout, so an inset expressed as geometry is discarded
    width: parent ? parent.width : implicitWidth
    implicitWidth: inner.implicitWidth + trail.implicitWidth + Theme.pad * 2 + root.insetX * 2 + (trail.implicitWidth > 0 ? Theme.gap : 0)
    implicitHeight: Math.max(inner.implicitHeight, trail.implicitHeight) + 12 + root.insetY * 2

    Rectangle {
        id: pill

        anchors.fill: parent
        anchors.leftMargin: root.insetX
        anchors.rightMargin: root.insetX
        anchors.topMargin: root.insetY
        anchors.bottomMargin: root.insetY
        radius: Theme.radius
        color: root.highlighted ? Config.selection : root.hoverable && mouse.containsMouse ? Config.chrome : "transparent"
    }

    Row {
        id: inner

        anchors.left: pill.left
        anchors.leftMargin: Theme.pad
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.gap
    }

    Row {
        id: trail

        anchors.right: pill.right
        anchors.rightMargin: Theme.pad
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.gap
    }

    // the whole row is the hit target, so the gaps between pills are not dead
    MouseArea {
        id: mouse

        anchors.fill: parent
        enabled: root.hoverable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
