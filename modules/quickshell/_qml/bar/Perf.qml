import Quickshell
import Quickshell.Io
import QtQuick
import qs
import qs.lib

Item {
    id: root

    property var bar
    property real cpuPct: 0
    property int tempC: 0
    property string tempChip: ""
    property real memUsed: 0
    property real memTotal: 0
    property int diskPct: 0
    property real prevTotal: 0
    property real prevIdle: 0

    function stateColor(value, warning, critical) {
        if (value >= critical)
            return Config.base08;
        if (value >= warning)
            return Config.base0A;
        return Config.base04;
    }

    implicitWidth: readout.implicitWidth
    implicitHeight: readout.implicitHeight

    Process {
        id: metricsProc

        command: [Config.metricsScript]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const m = JSON.parse(text);
                    if (root.prevTotal > 0 && m.total > root.prevTotal)
                        root.cpuPct = Math.round(100 * (1 - (m.idle - root.prevIdle) / (m.total - root.prevTotal)));
                    root.prevTotal = m.total;
                    root.prevIdle = m.idle;
                    root.tempC = m.tempC;
                    root.tempChip = m.tempChip;
                    root.memUsed = m.memUsed;
                    root.memTotal = m.memTotal;
                    root.diskPct = m.diskPct;
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 5000
        running: root.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: metricsProc.running = true
    }

    Text {
        id: readout

        text: root.bar.vertical ? "󰻠" : `󰻠 ${root.cpuPct}% ${root.tempC >= 55 ? "󰔏" : "󱃃"}${root.tempC}°C 󰍛 ${root.memUsed.toFixed(1)}G 󰋊 ${root.diskPct}%`
        color: root.stateColor(Math.max(root.cpuPct, root.diskPct - 10, (root.memUsed / Math.max(root.memTotal, 1)) * 100 - 10), 70, 90)
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
        visible: false

        Column {
            spacing: 6

            Repeater {
                model: [`󰻠 CPU        ${root.cpuPct}%`, `󰔏 ${root.tempChip}    ${root.tempC}°C`, `󰍛 Memory     ${root.memUsed.toFixed(1)}G / ${root.memTotal.toFixed(1)}G`, `󰋊 Disk /     ${root.diskPct}%`]

                Text {
                    required property string modelData

                    text: modelData
                    color: Config.base05
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }
            }

            Text {
                visible: Config.systemMonitorCommand !== ""
                text: "󱂬 open monitor"
                color: monitorMouse.containsMouse ? Config.base0D : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize

                MouseArea {
                    id: monitorMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.systemMonitorCommand}`]);
                        popup.visible = false;
                    }
                }
            }
        }
    }
}
