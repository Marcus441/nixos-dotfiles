import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs

PopupWindow {
    id: root

    property Item anchorItem
    property int contentPadding: 10
    property int barGap: 4
    default property alias content: container.data

    readonly property bool vertical: Config.barPosition === "left" || Config.barPosition === "right"
    readonly property var barWindow: root.anchorItem ? root.anchorItem.QsWindow.window : null
    readonly property int popupEdge: {
        switch (Config.barPosition) {
        case "bottom":
            return Edges.Top;
        case "left":
            return Edges.Right;
        case "right":
            return Edges.Left;
        default:
            return Edges.Bottom;
        }
    }

    function updateRect() {
        if (!root.barWindow || !root.anchorItem)
            return;
        const r = root.anchorItem.QsWindow.itemRect(root.anchorItem);
        root.anchor.rect = root.vertical ? Qt.rect(0, r.y, root.barWindow.width, r.height) : Qt.rect(r.x, 0, r.width, root.barWindow.height);
    }

    anchor.window: root.barWindow
    anchor.edges: root.popupEdge
    anchor.gravity: root.popupEdge
    implicitWidth: container.implicitWidth + root.contentPadding * 2 + (root.vertical ? root.barGap : 0)
    implicitHeight: container.implicitHeight + root.contentPadding * 2 + (root.vertical ? 0 : root.barGap)
    color: "transparent"

    Connections {
        target: root.anchor

        function onAnchoring() {
            root.updateRect();
        }
    }

    HyprlandFocusGrab {
        active: root.backingWindowVisible
        windows: root.barWindow ? [root, root.barWindow] : [root]
        onCleared: root.visible = false
    }

    Rectangle {
        id: frame

        anchors.fill: parent
        anchors.topMargin: Config.barPosition === "top" ? root.barGap : 0
        anchors.bottomMargin: Config.barPosition === "bottom" ? root.barGap : 0
        anchors.leftMargin: Config.barPosition === "left" ? root.barGap : 0
        anchors.rightMargin: Config.barPosition === "right" ? root.barGap : 0
        color: Config.base00
        border.color: Config.base02
        border.width: 1
        radius: 6
    }

    Item {
        id: container

        anchors.fill: frame
        anchors.margins: root.contentPadding
        implicitWidth: children.length > 0 ? children[0].implicitWidth : 0
        implicitHeight: children.length > 0 ? children[0].implicitHeight : 0
    }
}
