import Quickshell
import Quickshell.Io
import QtQuick
import qs

Item {
    id: root

    property var bar
    property string layout: "dwindle"

    readonly property bool monocle: layout === "monocle"

    function apply(name) {
        const t = name.trim();
        if (t.length > 0)
            root.layout = t;
    }

    implicitWidth: glyph.implicitWidth
    implicitHeight: glyph.implicitHeight

    FileView {
        id: stateFile

        path: `${Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache"}/hyprland-layout`
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: root.apply(text())
        onLoadFailed: fallbackProc.running = true
    }

    Process {
        id: fallbackProc

        command: [Config.hyprctl, "getoption", "general:layout", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.apply(JSON.parse(text).str);
                } catch (e) {}
                stateFile.setText(root.layout + "\n");
            }
        }
    }

    Text {
        id: glyph

        text: root.monocle ? "" : "󰙀"
        color: root.monocle ? Config.base0D : Config.base04
        font.family: Config.iconFamily
        font.pixelSize: Config.fontSize
    }
}
