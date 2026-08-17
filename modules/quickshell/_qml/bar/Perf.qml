import QtQuick
import qs
import qs.lib
import qs.services

Item {
    id: root

    property var bar

    function stateColor(value, warning, critical) {
        if (value >= critical)
            return Config.base08;
        if (value >= warning)
            return Config.base0A;
        return Config.base04;
    }

    implicitWidth: readout.implicitWidth
    implicitHeight: readout.implicitHeight

    Text {
        id: readout

        text: "󰓅"
        color: root.stateColor(Math.max(Metrics.cpuPct, Metrics.diskPct - 10, (Metrics.memUsed / Math.max(Metrics.memTotal, 1)) * 100 - 10), 70, 90)
        font.family: Config.iconFamily
        font.pixelSize: Config.fontSize

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: popup.visible = !popup.visible
        }
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "System"
        visible: false

        headerContent: [
            TextAction {
                visible: Config.systemMonitorCommand !== ""
                text: "󱂬 monitor"
                onTriggered: {
                    Config.launchApp(Config.systemMonitorCommand);
                    popup.visible = false;
                }
            }
        ]

        Repeater {
            model: [{
                text: `󰻠 CPU        ${Metrics.cpuPct}%`,
                command: Config.processorCommand
            }, {
                text: `󰔏 ${Metrics.tempChip}    ${Metrics.tempC}°C`,
                command: Config.temperatureCommand
            }, {
                text: ` Memory     ${Metrics.memUsed.toFixed(1)}G / ${Metrics.memTotal.toFixed(1)}G`,
                command: Config.memoryCommand
            }, {
                text: `󰋊 Disk /     ${Metrics.diskPct}%`,
                command: ""
            }]

            PopupRow {
                id: metricRow

                required property var modelData

                hoverable: modelData.command !== ""
                onClicked: {
                    Config.launchApp(metricRow.modelData.command);
                    popup.visible = false;
                }

                Text {
                    text: metricRow.modelData.text
                    color: Config.base05
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }
            }
        }
    }
}
