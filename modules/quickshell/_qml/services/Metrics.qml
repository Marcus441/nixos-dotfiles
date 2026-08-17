pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root

    property bool active: true
    property real cpuPct: 0
    property int tempC: 0
    property string tempChip: ""
    property real memUsed: 0
    property real memTotal: 0
    property int diskPct: 0
    property real prevTotal: 0
    property real prevIdle: 0

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
                } catch (e) {
                    console.warn("Metrics: unparseable collector output:", e.message);
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: root.active
        repeat: true
        triggeredOnStart: true
        onTriggered: metricsProc.running = true
    }
}
