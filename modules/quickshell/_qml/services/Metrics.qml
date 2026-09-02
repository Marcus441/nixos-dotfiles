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
    property var diskNames: []
    property var disks: ({})
    property real prevTotal: 0
    property real prevIdle: 0
    property var prevIo: ({})
    property real prevUpSec: 0

    function updateDisks(m): void {
        const elapsedMs = (m.upSec - root.prevUpSec) * 1000;
        const sampled = root.prevUpSec > 0 && elapsedMs > 0;
        const names = [];
        const next = {};
        const io = {};
        for (const d of m.disks) {
            const prev = root.prevIo[d.name];
            names.push(d.name);
            io[d.name] = d.ioMs;
            next[d.name] = {
                busy: sampled && prev !== undefined ? Math.max(0, Math.min(100, Math.round((d.ioMs - prev) / elapsedMs * 100))) : 0,
                usedK: 0,
                totalK: 0
            };
        }
        for (const mount of m.mounts) {
            const entry = next[mount.dev];
            if (entry) {
                entry.usedK += mount.used;
                entry.totalK += mount.blocks;
            }
        }
        root.prevIo = io;
        root.prevUpSec = m.upSec;
        root.disks = next;
        if (names.join(",") !== root.diskNames.join(","))
            root.diskNames = names;
    }

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
                    root.updateDisks(m);
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
