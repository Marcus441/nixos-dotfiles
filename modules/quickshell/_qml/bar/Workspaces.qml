import Quickshell.Hyprland
import QtQuick
import qs

Rectangle {
    id: root

    property var bar
    property int wsRev: 0

    readonly property var wsIds: {
        wsRev;
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values)
            ids.add(ws.id);
        return Array.from(ids).filter(i => i > 0).sort((a, b) => a - b);
    }

    color: Config.base01
    radius: bar.vertical ? 6 : height / 2
    implicitWidth: bar.vertical ? 22 : row.implicitWidth + 8
    implicitHeight: bar.vertical ? row.implicitHeight + 8 : 20

    Connections {
        target: Hyprland.workspaces

        function onObjectInsertedPost() {
            root.wsRev++;
        }

        function onObjectRemovedPost() {
            root.wsRev++;
        }
    }

    Grid {
        id: row

        anchors.centerIn: parent
        columns: root.bar.vertical ? 1 : root.wsIds.length
        spacing: 2

        Repeater {
            model: root.wsIds

            Rectangle {
                id: pill

                required property int modelData

                readonly property var ws: {
                    root.wsRev;
                    return Hyprland.workspaces.values.find(w => w.id === pill.modelData) ?? null;
                }
                readonly property bool focused: Hyprland.focusedWorkspace?.id === pill.modelData
                readonly property bool occupied: ws !== null
                readonly property bool urgent: ws?.urgent ?? false

                width: root.bar.vertical ? 16 : (focused ? 28 : 16)
                height: root.bar.vertical ? (focused ? 28 : 16) : 16
                radius: 8
                color: urgent ? Config.base08 : focused ? Config.base0D : "transparent"

                Behavior on width {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: pill.ws?.name ?? pill.modelData
                    color: pill.focused || pill.urgent ? Config.base00 : pill.occupied ? Config.base05 : Config.base04
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize - 1
                    font.weight: 600
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch(`workspace ${pill.modelData}`)
                }
            }
        }
    }
}
