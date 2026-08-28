pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property string pending: ""

    function send(request: string): void {
        root.pending = request;
        settle.restart();
    }

    function flush(): void {
        if (root.pending === "")
            return;
        const request = root.pending;
        root.pending = "";
        settle.stop();
        Hyprland.dispatch(request);
    }

    Connections {
        target: Hyprland
        enabled: root.pending !== ""

        function onRawEvent(event) {
            if (event.name === "activewindowv2")
                root.flush();
        }
    }

    Timer {
        id: settle

        interval: 200
        onTriggered: root.flush()
    }
}
