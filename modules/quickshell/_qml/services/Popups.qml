pragma Singleton
import Quickshell

Singleton {
    id: root

    property bool launcherOpen: false
    property bool clipboardOpen: false
    property bool wallpaperOpen: false
    property bool powerOpen: false

    function toggle(name: string): void {
        switch (name) {
        case "launcher":
            launcherOpen = !launcherOpen;
            break;
        case "clipboard":
            clipboardOpen = !clipboardOpen;
            break;
        case "wallpaper":
            wallpaperOpen = !wallpaperOpen;
            break;
        case "powermenu":
            powerOpen = !powerOpen;
            break;
        }
    }
}
