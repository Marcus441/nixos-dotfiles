pragma Singleton
import Quickshell

Singleton {
    id: root

    property string open: ""

    readonly property bool launcherOpen: open === "launcher"
    readonly property bool clipboardOpen: open === "clipboard"
    readonly property bool wallpaperOpen: open === "wallpaper"
    readonly property bool powerOpen: open === "powermenu"

    function toggle(name: string): void {
        open = open === name ? "" : name;
    }

    function close(name: string): void {
        if (open === name)
            open = "";
    }
}
