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

    readonly property var apps: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))

    onAppsChanged: {
        if (filterList)
            filterList.refilter();
    }

    function launch(app) {
        if (!app)
            return;
        Config.launchApp(`${app.id}.desktop`);
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
                const name = app.name.toLowerCase();
                if (name.startsWith(q))
                    starts.push(app);
                else if (name.includes(q) || (app.comment ?? "").toLowerCase().includes(q))
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
            }

            IconImage {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                implicitSize: 28
                asynchronous: true
                source: Quickshell.iconPath(row.modelData.icon, true)
            }

            Column {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: Theme.gap

                Text {
                    text: row.modelData.name
                    color: Config.textPrimary
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontLg
                }

                Text {
                    visible: (row.modelData.comment ?? "") !== ""
                    text: row.modelData.comment ?? ""
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
