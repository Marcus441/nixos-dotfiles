pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

PanelWindow {
    id: root

    signal dismissed

    property int selected: 0

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

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    color: Config.card

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.dismissed()
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: root.dismissed()
        Keys.onLeftPressed: root.selected = Math.max(0, root.selected - 1)
        Keys.onRightPressed: root.selected = Math.min(root.actions.length - 1, root.selected + 1)
        Keys.onReturnPressed: root.activate(root.actions[root.selected])

        Row {
            anchors.centerIn: parent
            spacing: 12

            Repeater {
                model: root.actions

                Rectangle {
                    id: tile

                    required property var modelData
                    required property int index
                    readonly property bool active: mouse.containsMouse || root.selected === index

                    width: 180
                    height: 200
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
                        onEntered: root.selected = tile.index
                        onClicked: root.activate(tile.modelData)
                    }
                }
            }
        }
    }
}
