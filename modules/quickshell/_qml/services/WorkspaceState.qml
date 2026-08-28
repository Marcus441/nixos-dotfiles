pragma Singleton
import Quickshell
import Quickshell.Hyprland
import QtQuick
import qs.lib

Singleton {
    id: root

    readonly property var ids: {
        watcher.rev;
        const seen = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values)
            seen.add(ws.id);
        return Array.from(seen);
    }

    readonly property var byId: {
        watcher.rev;
        const map = {};
        for (const ws of Hyprland.workspaces.values)
            map[ws.id] = ws;
        return map;
    }

    ModelWatcher {
        id: watcher

        model: Hyprland.workspaces
    }
}
