import Quickshell
import QtQuick
import qs

PopupWindow {
    id: root

    property Item anchorItem
    property int contentPadding: 10
    default property alias content: container.data

    anchor.item: anchorItem
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    implicitWidth: container.implicitWidth + contentPadding * 2
    implicitHeight: container.implicitHeight + contentPadding * 2
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Config.base00
        border.color: Config.base02
        border.width: 1
        radius: 6
    }

    Item {
        id: container

        anchors.fill: parent
        anchors.margins: root.contentPadding
        implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
        implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
    }
}
