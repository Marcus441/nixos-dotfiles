pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    property int selected: 0
    readonly property int tileWidth: 180
    readonly property int tileHeight: 200
    readonly property int tileGap: 12

    // lock delegates to lock.command (loginctl lock-session); never WlSessionLock
    readonly property var actions: [
        {
            glyph: "󰌾",
            label: "Lock",
            tint: Config.accent,
            cmd: [Config.sh, "-c", Config.lockCommand],
            show: Config.lockCommand !== ""
        },
        {
            glyph: "󰍃",
            label: "Logout",
            tint: Config.base0C,
            cmd: [Config.sh, "-c", Config.logoutCommand],
            show: Config.logoutCommand !== ""
        },
        {
            glyph: "󰒲",
            label: "Suspend",
            tint: Config.base0A,
            cmd: [Config.systemctl, "suspend"],
            show: true
        },
        {
            glyph: "󰜉",
            label: "Reboot",
            tint: Config.base0E,
            cmd: [Config.systemctl, "reboot"],
            show: true
        },
        {
            glyph: "󰐥",
            label: "Shutdown",
            tint: Config.base08,
            cmd: [Config.systemctl, "poweroff"],
            show: true
        }
    ].filter(a => a.show)

    function activate(action) {
        Quickshell.execDetached(action.cmd);
        root.dismissed();
    }

    WlrLayershell.namespace: "quickshell-powermenu"
    contentWidth: root.actions.length * root.tileWidth + (root.actions.length - 1) * root.tileGap + Theme.pad * 2
    contentHeight: root.tileHeight + Theme.pad * 2

    PointerGuard {
        id: hoverGuard
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.dismissed()
        Keys.onLeftPressed: root.selected = Math.max(0, root.selected - 1)
        Keys.onRightPressed: root.selected = Math.min(root.actions.length - 1, root.selected + 1)
        Keys.onReturnPressed: root.activate(root.actions[root.selected])
        Keys.onEnterPressed: root.activate(root.actions[root.selected])

        Row {
            anchors.centerIn: parent
            spacing: root.tileGap

            Repeater {
                model: root.actions

                Rectangle {
                    id: tile

                    required property var modelData
                    required property int index
                    readonly property bool active: mouse.containsMouse || root.selected === index

                    width: root.tileWidth
                    height: root.tileHeight
                    color: tile.active ? Config.selection : Config.chrome

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durFast
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.glyph
                            color: tile.modelData.tint
                            font.family: Config.iconFamily
                            font.pixelSize: Theme.fontXxl
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.label
                            color: Config.textPrimary
                            font.family: Config.fontFamily
                            font.pixelSize: Theme.fontLg
                        }
                    }

                    MouseArea {
                        id: mouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onPositionChanged: mouse => {
                            const p = tile.mapToItem(null, mouse.x, mouse.y);
                            if (hoverGuard.moved(p.x, p.y))
                                root.selected = tile.index;
                        }
                        onClicked: root.activate(tile.modelData)
                    }
                }
            }
        }
    }
}
