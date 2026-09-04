pragma Singleton
import Quickshell

Singleton {
    id: root

    property string open: ""

    readonly property bool launcherOpen: open === "launcher"
    readonly property bool clipboardOpen: open === "clipboard"
    readonly property bool switcherOpen: open === "switcher"
    readonly property bool powerOpen: open === "powermenu"
    readonly property bool wallpaperOpen: open === "wallpaper"

    function toggle(name: string): void {
        open = open === name ? "" : name;
    }

    function close(name: string): void {
        if (open === name)
            open = "";
    }
}
