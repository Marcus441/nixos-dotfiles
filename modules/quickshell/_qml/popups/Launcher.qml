pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    WlrLayershell.namespace: "quickshell-launcher"

    contentWidth: 680
    contentHeight: 500

    readonly property var apps: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name)).map(a => ({
                entry: a,
                name: a.name.toLowerCase(),
                comment: (a.comment ?? "").toLowerCase()
            }))

    onAppsChanged: {
        if (filterList)
            filterList.refilter();
    }

    function launch(app) {
        if (!app)
            return;
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
                return root.apps;
            const starts = [];
            const contains = [];
            for (const app of root.apps) {
                if (app.name.startsWith(q))
                    starts.push(app);
                else if (app.name.includes(q) || app.comment.includes(q))
                    contains.push(app);
            }
            return starts.concat(contains);
        }
        onDismissed: root.dismissed()
        onAccepted: root.launch(filterList.filtered[filterList.selected])

        delegate: Item {
            id: row

            required property var modelData
            required property int index

            width: filterList.width
            height: Theme.rowIcon

            Rectangle {
                anchors.fill: parent
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
