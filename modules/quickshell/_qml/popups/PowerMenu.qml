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
            key: "l",
            tint: Config.base0D,
            cmd: [Config.sh, "-c", Config.lockCommand],
            show: Config.lockCommand !== ""
        },
        {
            glyph: "󰍃",
            label: "Logout",
            key: "e",
            tint: Config.base0C,
            cmd: [Config.sh, "-c", Config.logoutCommand],
            show: Config.logoutCommand !== ""
        },
        {
            glyph: "󰒲",
            label: "Suspend",
            key: "u",
            tint: Config.base0A,
            cmd: [Config.systemctl, "suspend"],
            show: true
        },
        {
            glyph: "󰜉",
            label: "Reboot",
            key: "r",
            tint: Config.base0E,
            cmd: [Config.systemctl, "reboot"],
            show: true
        },
        {
            glyph: "󰐥",
            label: "Shutdown",
            key: "s",
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
    color: Config.base10

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
        Keys.onPressed: event => {
            const hit = root.actions.find(a => a.key === event.text);
            if (hit) {
                root.activate(hit);
                event.accepted = true;
            }
        }

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
                    color: tile.active ? Config.base02 : Config.base01

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
                            font.pixelSize: Config.fontSize + 28
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.label
                            color: Config.base05
                            font.family: Config.fontFamily
                            font.pixelSize: Theme.fontLg
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.key
                            color: tile.active ? Config.base05 : Config.base03
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize
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
