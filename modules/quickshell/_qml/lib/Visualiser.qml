pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.Pipewire
import qs

Item {
    id: root

    property PwNode node: null
    property bool active: false
    property color fill: Config.accent
    property int bars: 5
    property int barWidth: 2
    property int gap: 2
    property int restHeight: 2

    property real attack: 0.1
    property real release: 0.006
    property real headroom: 1.7
    property real minSpan: 0.05

    property real lowRef: 0
    property real highRef: 0.1
    property var levels: []

    readonly property bool sampling: root.active && root.visible
    readonly property bool draining: root.levels.some(v => v > 0.01)

    implicitWidth: root.bars * root.barWidth + (root.bars - 1) * root.gap
    implicitHeight: 12

    Component.onCompleted: root.levels = new Array(root.bars).fill(0)

    // the sink reports one amplitude, not a spectrum, so the bars are its recent
    // history: newest on the right, each older sample shifted one bar left
    function sample(): void {
        const peak = root.sampling ? monitor.peak : 0;
        root.highRef += (peak - root.highRef) * (peak > root.highRef ? root.attack : root.release);
        root.lowRef += (peak - root.lowRef) * (peak < root.lowRef ? root.attack : root.release);
        root.levels = root.levels.slice(1).concat([root.levelFor(peak)]);
    }

    // a limited source's peak barely moves in absolute terms, so a bar shows
    // where the sample sits inside the signal's own recent range; headroom
    // keeps ordinary peaks off the ceiling so a loud one still has somewhere to go
    function levelFor(peak: real): real {
        const span = Math.max(root.minSpan, (root.highRef - root.lowRef) * root.headroom);
        return Math.max(0, Math.min(1, (peak - root.lowRef) / span));
    }

    PwNodePeakMonitor {
        id: monitor

        node: root.node
        enabled: root.sampling
    }

    Timer {
        running: root.sampling || root.draining
        interval: 70
        repeat: true
        onTriggered: root.sample()
    }

    Repeater {
        model: root.bars

        Rectangle {
            id: bar

            required property int index

            readonly property real level: root.levels[bar.index] ?? 0

            x: bar.index * (root.barWidth + root.gap)
            y: root.height - bar.height
            width: root.barWidth
            height: Math.max(root.restHeight, root.height * bar.level)
            radius: Math.round(root.barWidth / 2)
            color: root.fill

            Behavior on height {
                NumberAnimation {
                    duration: 90
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
