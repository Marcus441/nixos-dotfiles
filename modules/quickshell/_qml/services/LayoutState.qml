pragma Singleton
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs

Singleton {
    id: root

    property string layout: "dwindle"

    readonly property bool monocle: layout === "monocle"

    Component.onCompleted: queryProc.running = true

    function apply(name) {
        const t = name.trim();
        if (t.length > 0)
            root.layout = t;
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "custom") {
                const m = event.data.match(/^layout,(.+)$/);
                if (m)
                    root.apply(m[1]);
            } else if (event.name === "configreloaded") {
                queryProc.running = true;
            }
        }
    }

    Process {
        id: queryProc

        command: [Config.hyprctl, "getoption", "general:layout", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.apply(JSON.parse(text).str);
                } catch (e) {
                    console.warn("LayoutState: unparseable hyprctl output:", e.message);
                }
            }
        }
    }
}
