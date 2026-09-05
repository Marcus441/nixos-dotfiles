pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.lib
import qs.services

Overlay {
    id: root

    WlrLayershell.namespace: "quickshell-launcher"

    readonly property var apps: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name)).map(a => ({
                entry: a,
                name: a.name.toLowerCase(),
                comment: (a.comment ?? "").toLowerCase(),
                keywords: Array.from(a.keywords ?? []).map(k => k.toLowerCase()),
                exec: (a.execString ?? "").toLowerCase()
            }))

    onAppsChanged: {
        if (filterList)
            filterList.refilter();
    }

    // every letter of the query in order, so "gimp" still finds GNU Image
    // Manipulation Program
    function subsequence(haystack, needle) {
        let i = 0;
        for (const ch of haystack) {
            if (ch === needle[i] && ++i === needle.length)
                return true;
        }
        return false;
    }

    function tierOf(app, q) {
        if (app.name.startsWith(q))
            return 0;
        if (app.name.includes(q))
            return 1;
        if (app.keywords.some(k => k.includes(q)))
            return 2;
        if (app.comment.includes(q))
            return 3;
        if (app.exec.includes(q))
            return 4;
        return root.subsequence(app.name, q) ? 5 : -1;
    }

    // ties break alphabetically, so an unused list stays in name order
    function byUse(list) {
        return list.slice().sort((a, b) => LauncherUsage.score(b.entry.id) - LauncherUsage.score(a.entry.id) || a.name.localeCompare(b.name));
    }

    function launch(app) {
        if (!app)
            return;
        LauncherUsage.record(app.entry.id);
        Config.launchApp(`${app.entry.id}.desktop`);
        root.dismissed();
    }

    PointerGuard {
        id: hoverGuard
    }

    FilterList {
        id: filterList

        anchors.fill: parent
        placeholder: "Search applications…"
        emptyText: "No applications match"
        searchIcon: "󰍉"
        searchPixelSize: Theme.fontXl
        filterFn: q => {
            if (q === "")
                return root.byUse(root.apps);
            const tiers = [[], [], [], [], [], []];
            for (const app of root.apps) {
                const tier = root.tierOf(app, q);
                if (tier >= 0)
                    tiers[tier].push(app);
            }
            const ranked = tiers.map(t => root.byUse(t));
            return ranked[0].concat(ranked[1], ranked[2], ranked[3], ranked[4], ranked[5]);
        }
        onDismissed: root.dismissed()
        onAccepted: root.launch(filterList.filtered[filterList.selected])

        delegate: Item {
            id: row

            required property var modelData
            required property int index

            width: filterList.rowWidth
            height: Theme.rowIcon

            Rectangle {
                anchors.fill: parent
                radius: Theme.radius
                color: row.index === filterList.selected ? Config.selection : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.durFast
                    }
                }
            }

            IconImage {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                implicitSize: 28
                asynchronous: true
                source: Quickshell.iconPath(row.modelData.entry.icon, true)
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: Theme.gap

                Text {
                    text: row.modelData.entry.name
                    color: Config.textPrimary
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontLg
                }

                Text {
                    visible: row.modelData.comment !== ""
                    text: row.modelData.entry.comment ?? ""
                    color: Config.textSecondary
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize + 1
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPositionChanged: mouse => {
                    const p = row.mapToItem(null, mouse.x, mouse.y);
                    if (hoverGuard.moved(p.x, p.y))
                        filterList.selected = row.index;
                }
                onClicked: root.launch(row.modelData)
            }
        }
    }
}
