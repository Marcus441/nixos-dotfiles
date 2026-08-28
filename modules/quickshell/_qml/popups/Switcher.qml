pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.lib
import qs.services

Overlay {
    id: root

    WlrLayershell.namespace: "quickshell-switcher"

    contentWidth: 640
    contentHeight: 520

    property var collapsed: ({})

    readonly property bool showMonitor: Hyprland.monitors.values.length > 1

    readonly property var groups: {
        wsWatch.rev;
        tlWatch.rev;

        const wins = {};
        for (const tl of Hyprland.toplevels.values) {
            const ws = tl.workspace;
            if (!ws)
                continue;
            const appId = tl.wayland?.appId ?? tl.lastIpcObject?.class ?? "";
            if (!wins[ws.id])
                wins[ws.id] = [];
            wins[ws.id].push({
                kind: "win",
                wsId: ws.id,
                tl: tl,
                appId: appId,
                search: `${appId} ${tl.title}`.toLowerCase()
            });
        }

        const live = {};
        const ids = new Set([1, 2, 3, 4, 5]);
        for (const ws of Hyprland.workspaces.values) {
            live[ws.id] = ws;
            ids.add(ws.id);
        }

        return Array.from(ids).filter(id => id > 0 || (wins[id] ?? []).length > 0).sort((a, b) => (a > 0) === (b > 0) ? a - b : b - a).map(id => {
            const ws = live[id] ?? null;
            const children = wins[id] ?? [];
            const name = ws?.name ?? `${id}`;
            return {
                id: id,
                wins: children,
                header: {
                    kind: "ws",
                    id: id,
                    ws: ws,
                    name: name,
                    count: children.length,
                    monitor: ws?.monitor?.name ?? "",
                    search: name.toLowerCase()
                }
            };
        });
    }

    function rowsFor(q) {
        const out = [];
        for (const group of root.groups) {
            const hit = q !== "" && group.header.search.includes(q);
            const wins = q === "" || hit ? group.wins : group.wins.filter(w => w.search.includes(q));
            if (q !== "" && !hit && wins.length === 0)
                continue;
            out.push(group.header);
            if (q !== "" || !root.collapsed[group.id])
                for (const win of wins)
                    out.push(win);
        }
        return out;
    }

    function setCollapsed(id, value) {
        const next = {};
        for (const key in root.collapsed)
            next[key] = root.collapsed[key];
        if (value)
            next[id] = true;
        else
            delete next[id];
        root.collapsed = next;
        filterList.refilter();
        filterList.selected = Math.max(0, filterList.filtered.findIndex(r => r.kind === "ws" && r.id === id));
    }

    function request(row) {
        if (row.kind === "ws")
            return Hyprland.usingLua ? `hl.dsp.focus({ workspace = "${row.id}" })` : `workspace ${row.id}`;
        return Hyprland.usingLua ? `hl.dsp.focus({ window = "address:0x${row.tl.address}" })` : `focuswindow address:0x${row.tl.address}`;
    }

    function activate(row) {
        if (!row)
            return;
        FocusRequest.send(root.request(row));
        root.dismissed();
    }

    ModelWatcher {
        id: wsWatch

        model: Hyprland.workspaces
    }

    ModelWatcher {
        id: tlWatch

        model: Hyprland.toplevels
    }

    Component.onCompleted: Hyprland.refreshToplevels()

    onGroupsChanged: {
        if (filterList)
            filterList.refilter();
    }

    FilterList {
        id: filterList

        anchors.fill: parent
        placeholder: "Search windows…"
        searchIcon: "󰍉"
        searchPixelSize: Theme.fontXl
        treeKeys: true
        filterFn: q => root.rowsFor(q)
        onDismissed: root.dismissed()
        onAccepted: {
            const row = filterList.filtered[filterList.selected];
            if (!row)
                return;
            if (row.kind === "ws" && row.count > 0 && filterList.query === "")
                root.setCollapsed(row.id, !root.collapsed[row.id]);
            else
                root.activate(row);
        }

        onCollapsed: {
            const row = filterList.filtered[filterList.selected];
            if (row)
                root.setCollapsed(row.kind === "ws" ? row.id : row.wsId, true);
        }

        onExpanded: {
            const row = filterList.filtered[filterList.selected];
            if (!row || row.kind === "win")
                return;
            if (root.collapsed[row.id])
                root.setCollapsed(row.id, false);
            else if (filterList.filtered[filterList.selected + 1]?.kind === "win")
                filterList.selected += 1;
        }

        delegate: Item {
            id: row

            required property var modelData
            required property int index

            readonly property bool isNode: modelData.kind === "ws"
            readonly property bool current: index === filterList.selected

            width: filterList.width
            height: isNode ? 32 : 40

            Rectangle {
                anchors.fill: parent
                color: row.current ? Config.base02 : "transparent"
            }

            Row {
                visible: row.isNode
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                spacing: Theme.gap

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: row.modelData.count > 0
                    text: root.collapsed[row.modelData.id] ? "󰅂" : "󰅀"
                    color: Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: row.isNode ? row.modelData.name : ""
                    color: row.modelData.ws?.urgent ? Config.base08 : row.modelData.ws?.focused ? Config.base0D : Config.base05
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontMd
                    font.weight: 600
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: !row.isNode ? "" : row.modelData.count === 0 ? "empty" : row.modelData.count === 1 ? "1 window" : `${row.modelData.count} windows`
                    color: Config.base03
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }

            Text {
                visible: row.isNode && root.showMonitor && row.modelData.monitor !== ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                text: row.isNode ? row.modelData.monitor : ""
                color: Config.base03
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }

            IconImage {
                id: icon

                visible: !row.isNode
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad * 2 + Theme.gap
                implicitSize: 22
                asynchronous: true
                source: row.isNode ? "" : Quickshell.iconPath(DesktopEntries.heuristicLookup(row.modelData.appId)?.icon ?? row.modelData.appId, true)
            }

            Row {
                visible: !row.isNode
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: Theme.gap
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                spacing: Theme.gap

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(implicitWidth, parent.width - appLabel.width - parent.spacing)
                    text: row.isNode ? "" : row.modelData.tl.title
                    elide: Text.ElideRight
                    color: !row.isNode && row.modelData.tl.wayland === ToplevelManager.activeToplevel ? Config.base0D : Config.base05
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontMd
                }

                Text {
                    id: appLabel

                    anchors.verticalCenter: parent.verticalCenter
                    text: row.isNode ? "" : row.modelData.appId
                    color: Config.base03
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: filterList.selected = row.index
                onClicked: mouse => {
                    if (row.isNode && mouse.x < Theme.pad * 2 + Theme.gap && row.modelData.count > 0)
                        root.setCollapsed(row.modelData.id, !root.collapsed[row.modelData.id]);
                    else
                        root.activate(row.modelData);
                }
            }
        }
    }
}
