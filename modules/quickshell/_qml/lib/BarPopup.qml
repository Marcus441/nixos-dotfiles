import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs

PopupWindow {
    id: root

    property Item anchorItem
    property string title: ""
    property int barGap: 4
    property int minWidth: 240
    default property alias content: contentColumn.data
    property alias headerContent: headerExtra.data

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
    implicitWidth: Math.max(root.title !== "" ? headerRow.implicitWidth + Theme.pad * 2 : 0, contentColumn.implicitWidth, root.minWidth) + (root.vertical ? root.barGap : 0)
    implicitHeight: header.height + contentColumn.implicitHeight + 16 + (root.vertical ? 0 : root.barGap)
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
        color: Config.card
        radius: Theme.radius
        border.width: Theme.border
        border.color: Config.chrome
    }

    Rectangle {
        id: header

        visible: root.title !== ""
        anchors.top: frame.top
        anchors.left: frame.left
        anchors.right: frame.right
        height: visible ? headerRow.implicitHeight + 20 : 0
        color: Config.chrome
        topLeftRadius: Theme.radius
        topRightRadius: Theme.radius

        Row {
            id: headerRow

            anchors.left: parent.left
            anchors.leftMargin: Theme.pad
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.pad

            Text {
                text: root.title
                color: Config.textPrimary
                font.family: Config.fontFamily
                font.pixelSize: Theme.fontMd
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                id: headerExtra

                spacing: Theme.pad
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Column {
        id: contentColumn

        anchors.top: header.bottom
        anchors.topMargin: Theme.gap
        anchors.left: frame.left
        anchors.right: frame.right
    }
}
