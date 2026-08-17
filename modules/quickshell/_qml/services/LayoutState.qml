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
            if (event.name === "configreloaded")
                queryProc.running = true;
        }
    }

    FileView {
        id: stateFile

        path: `${Config.cacheDir}/hyprland-layout`
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: root.apply(text())
        onLoadFailed: queryProc.running = true
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
                stateFile.setText(root.layout + "\n");
            }
        }
    }
}
