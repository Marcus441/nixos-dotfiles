pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import qs
import qs.lib

Rectangle {
    id: root

    required property Bar bar

    readonly property var wsIds: {
        wsWatch.rev;
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values)
            ids.add(ws.id);
        return Array.from(ids).filter(i => i > 0).sort((a, b) => a - b);
    }

    color: Config.base01
    radius: bar.vertical ? 6 : height / 2
    implicitWidth: bar.vertical ? 22 : row.implicitWidth + 8
    implicitHeight: bar.vertical ? row.implicitHeight + 8 : 20

    ModelWatcher {
        id: wsWatch

        model: Hyprland.workspaces
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
                    wsWatch.rev;
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
                        duration: Theme.durFast
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: Theme.durFast
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
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (pill.ws)
                            pill.ws.activate();
                        else
                            Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus({ workspace = "${pill.modelData}" })` : `workspace ${pill.modelData}`);
                    }
                }
            }
        }
    }
}
