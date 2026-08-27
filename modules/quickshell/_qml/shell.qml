pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import qs.popups
import qs.services

ShellRoot {
    id: shellRoot

    property bool barVisible: true

    // first access kicks DesktopEntries' lazy scan; without it the launcher's
    // first open races the scan and renders an empty list
    Component.onCompleted: DesktopEntries.applications.values

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData
            screen: modelData
            visible: shellRoot.barVisible
        }
    }

    LazyLoader {
        active: Popups.launcherOpen

        Launcher {
            onDismissed: Popups.close("launcher")
        }
    }

    LazyLoader {
        active: Popups.clipboardOpen

        Clipboard {
            onDismissed: Popups.close("clipboard")
        }
    }

    LazyLoader {
        active: Popups.powerOpen

        PowerMenu {
            onDismissed: Popups.close("powermenu")
        }
    }

    LazyLoader {
        active: Notifs.popups.length > 0

        Toasts {}
    }

    Binding {
        target: Metrics
        property: "active"
        value: shellRoot.barVisible
    }

    IpcHandler {
        target: "bar"

        function toggle(): void {
            shellRoot.barVisible = !shellRoot.barVisible;
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            Popups.toggle("launcher");
        }
    }

    IpcHandler {
        target: "clipboard"

        function toggle(): void {
            Popups.toggle("clipboard");
        }
    }

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            Popups.toggle("powermenu");
        }
    }

    IpcHandler {
        target: "media"

        function playPause(): void {
            MediaService.playPause();
        }

        function next(): void {
            MediaService.next();
        }

        function previous(): void {
            MediaService.previous();
        }
    }
}
