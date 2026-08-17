import Quickshell
import Quickshell.Io
import QtQuick
import qs.popups
import qs.services

ShellRoot {
    id: shellRoot

    property bool barVisible: true

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
            onDismissed: Popups.launcherOpen = false
        }
    }

    LazyLoader {
        active: Popups.clipboardOpen

        Clipboard {
            onDismissed: Popups.clipboardOpen = false
        }
    }

    LazyLoader {
        active: Popups.wallpaperOpen

        WallpaperPicker {
            onDismissed: Popups.wallpaperOpen = false
        }
    }

    LazyLoader {
        active: Popups.powerOpen

        PowerMenu {
            onDismissed: Popups.powerOpen = false
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
        target: "wallpaper"

        function toggle(): void {
            Popups.toggle("wallpaper");
        }
    }

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            Popups.toggle("powermenu");
        }
    }
}
