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
            shell: shellRoot
        }
    }

    LazyLoader {
        id: launcherLoader

        Launcher {
            onDismissed: launcherLoader.active = false
        }
    }

    LazyLoader {
        id: clipboardLoader

        Clipboard {
            onDismissed: clipboardLoader.active = false
        }
    }

    LazyLoader {
        id: wallpaperLoader

        WallpaperPicker {
            onDismissed: wallpaperLoader.active = false
        }
    }

    LazyLoader {
        id: powerLoader

        PowerMenu {
            onDismissed: powerLoader.active = false
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

    function toggleLauncher(): void {
        launcherLoader.active = !launcherLoader.active;
    }

    function toggleClipboard(): void {
        clipboardLoader.active = !clipboardLoader.active;
    }

    function toggleWallpaper(): void {
        wallpaperLoader.active = !wallpaperLoader.active;
    }

    function togglePower(): void {
        powerLoader.active = !powerLoader.active;
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
            shellRoot.toggleLauncher();
        }
    }

    IpcHandler {
        target: "clipboard"

        function toggle(): void {
            shellRoot.toggleClipboard();
        }
    }

    IpcHandler {
        target: "wallpaper"

        function toggle(): void {
            shellRoot.toggleWallpaper();
        }
    }

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            shellRoot.togglePower();
        }
    }
}
