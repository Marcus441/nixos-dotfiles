pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import qs
import qs.services

Rectangle {
    id: root

    required property Bar bar

    readonly property var wsIds: WorkspaceState.ids.filter(i => i > 0).sort((a, b) => a - b)

    color: Config.chrome
    radius: bar.vertical ? 6 : height / 2
    implicitWidth: bar.vertical ? 22 : row.implicitWidth + 8
    implicitHeight: bar.vertical ? row.implicitHeight + 8 : 20

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

                readonly property var ws: WorkspaceState.byId[pill.modelData] ?? null
                readonly property bool focused: Hyprland.focusedWorkspace?.id === pill.modelData
                readonly property bool occupied: ws !== null
                readonly property bool urgent: ws?.urgent ?? false

                width: root.bar.vertical ? 16 : (focused ? 28 : 16)
                height: root.bar.vertical ? (focused ? 28 : 16) : 16
                radius: 8
                color: urgent ? Config.base08 : focused ? Config.accent : "transparent"

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
                    color: pill.focused || pill.urgent ? Config.base00 : pill.occupied ? Config.textPrimary : Config.textSecondary
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
