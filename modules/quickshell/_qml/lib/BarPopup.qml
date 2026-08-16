import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs

PopupWindow {
    id: root

    property Item anchorItem
    property string title: ""
    property int barGap: 4
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
    implicitWidth: Math.max(root.title !== "" ? headerRow.implicitWidth + 28 : 0, contentColumn.implicitWidth, 240) + (root.vertical ? root.barGap : 0)
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
        color: Config.base10
    }

    Rectangle {
        id: header

        visible: root.title !== ""
        anchors.top: frame.top
        anchors.left: frame.left
        anchors.right: frame.right
        height: visible ? headerRow.implicitHeight + 20 : 0
        color: Config.base01

        Row {
            id: headerRow

            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            Text {
                text: root.title
                color: Config.base05
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize + 2
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                id: headerExtra

                spacing: 14
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Column {
        id: contentColumn

        anchors.top: header.bottom
        anchors.topMargin: 8
        anchors.left: frame.left
        anchors.right: frame.right
    }
}
