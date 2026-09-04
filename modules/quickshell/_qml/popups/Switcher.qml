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
    property var pointer: null

    readonly property bool showMonitor: {
        monWatch.rev;
        return Hyprland.monitors.values.length > 1;
    }

    readonly property var groups: {
        tlWatch.rev;

        const wins = {};
        for (const tl of Hyprland.toplevels.values) {
            const ws = tl.workspace;
            if (!ws)
                continue;
            const appId = tl.wayland?.appId || tl.lastIpcObject?.class || "";
            if (!wins[ws.id])
                wins[ws.id] = [];
            wins[ws.id].push({
                kind: "win",
                wsId: ws.id,
                address: tl.address,
                appId: appId,
                icon: Quickshell.iconPath(DesktopEntries.heuristicLookup(appId)?.icon ?? appId, true)
            });
        }

        const live = WorkspaceState.byId;
        return WorkspaceState.ids.filter(id => id > 0 || (wins[id] ?? []).length > 0).sort((a, b) => (a > 0) === (b > 0) ? a - b : b - a).map(id => {
            const ws = live[id] ?? null;
            const children = wins[id] ?? [];
            const name = ws?.name ?? `${id}`;
            return {
                id: id,
                wins: children,
                header: {
                    kind: "ws",
                    id: id,
                    name: name,
                    count: children.length,
                    monitor: ws?.monitor?.name ?? "",
                    search: name.toLowerCase(),
                    first: children[0] ?? null
                }
            };
        });
    }

    // a row keeps an address, never the toplevel: a JavaScript object is not a
    // QML property, so nothing nulls a member of one when Hyprland destroys the
    // window behind it, and a binding would then read freed memory
    function toplevelFor(address: string): HyprlandToplevel {
        return Hyprland.toplevels.values.find(t => t.address === address) ?? null;
    }

    function rowsFor(q) {
        const out = [];
        for (const group of root.groups) {
            const hit = q !== "" && group.header.search.includes(q);
            const wins = q === "" || hit ? group.wins : group.wins.filter(w => `${w.appId} ${root.toplevelFor(w.address)?.title ?? ""}`.toLowerCase().includes(q));
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

    // the surface maps under the pointer, and the enter-plus-motion Wayland
    // sends then makes Qt report a hover with no movement in it; only a
    // position that actually changed may take the selection
    function hoverSelect(index, x, y) {
        const moved = root.pointer !== null && (root.pointer.x !== x || root.pointer.y !== y);
        root.pointer = Qt.point(x, y);
        if (moved)
            filterList.selected = index;
    }

    function initialIndex(rows, q) {
        const leaf = rows.findIndex(r => r.kind === "win");
        if (q !== "")
            return Math.max(0, leaf);
        // a bare open is an alt-tab: start on the window focused before this one
        const previous = rows.findIndex(r => r.kind === "win" && root.toplevelFor(r.address)?.lastIpcObject?.focusHistoryID === 1);
        return previous >= 0 ? previous : Math.max(0, leaf);
    }

    function windowRequest(address) {
        return Hyprland.usingLua ? `hl.dsp.focus({ window = "address:0x${address}" })` : `focuswindow address:0x${address}`;
    }

    function request(row) {
        if (row.kind === "win")
            return root.windowRequest(row.address);
        // a negative id is a relative jump to Hyprland, not a workspace; a
        // special is reached by focusing something inside it
        if (row.id < 0)
            return row.first ? root.windowRequest(row.first.address) : "";
        return Hyprland.usingLua ? `hl.dsp.focus({ workspace = "${row.id}" })` : `workspace ${row.id}`;
    }

    function activate(row) {
        if (!row)
            return;
        const req = root.request(row);
        if (req === "")
            return;
        FocusRequest.send(req);
        root.dismissed();
    }

    ModelWatcher {
        id: tlWatch

        model: Hyprland.toplevels
    }

    ModelWatcher {
        id: monWatch

        model: Hyprland.monitors
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
        selectFn: (rows, q) => root.initialIndex(rows, q)
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

        // a query force-expands the tree, so folding under one would record
        // hidden state and move the cursor for nothing -- the rule Enter follows
        onCollapsed: {
            const row = filterList.filtered[filterList.selected];
            if (row && filterList.query === "")
                root.setCollapsed(row.kind === "ws" ? row.id : row.wsId, true);
        }

        onExpanded: {
            const row = filterList.filtered[filterList.selected];
            if (!row || row.kind === "win" || filterList.query !== "")
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

            readonly property bool current: index === filterList.selected

            width: filterList.width
            height: modelData.kind === "ws" ? Theme.rowNode : Theme.rowLeaf

            Rectangle {
                anchors.fill: parent
                color: row.current ? Config.selection : "transparent"
            }

            Loader {
                anchors.fill: parent
                sourceComponent: row.modelData.kind === "ws" ? nodeRow : leafRow

                readonly property var entry: row.modelData
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                // movement, not entry: a reflow under a still pointer would
                // otherwise discard the selection the list just computed
                onPositionChanged: mouse => {
                    const p = row.mapToItem(null, mouse.x, mouse.y);
                    root.hoverSelect(row.index, p.x, p.y);
                }
                onClicked: mouse => {
                    const entry = row.modelData;
                    if (entry.kind === "ws" && mouse.x < Theme.pad * 2 + Theme.gap && entry.count > 0)
                        root.setCollapsed(entry.id, !root.collapsed[entry.id]);
                    else
                        root.activate(entry);
                }
            }
        }
    }

    Component {
        id: nodeRow

        Item {
            id: node

            readonly property var entry: parent.entry
            readonly property HyprlandWorkspace ws: WorkspaceState.byId[node.entry.id] ?? null

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                spacing: Theme.gap

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: node.entry.count > 0
                    text: root.collapsed[node.entry.id] ? "󰅂" : "󰅀"
                    color: Config.textSecondary
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: node.entry.name
                    color: node.ws?.urgent ? Config.base08 : node.ws?.focused ? Config.accent : Config.textPrimary
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontMd
                    font.weight: 600
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: node.entry.count === 0 ? "empty" : node.entry.count === 1 ? "1 window" : `${node.entry.count} windows`
                    color: Config.textMuted
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }

            Text {
                visible: root.showMonitor && node.entry.monitor !== ""
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                text: node.entry.monitor
                color: Config.textMuted
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }
    }

    Component {
        id: leafRow

        Item {
            id: leaf

            readonly property var entry: parent.entry
            readonly property HyprlandToplevel tl: root.toplevelFor(leaf.entry.address)

            IconImage {
                id: icon

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad * 2 + Theme.gap
                implicitSize: 22
                asynchronous: true
                source: leaf.entry.icon
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: icon.right
                anchors.leftMargin: Theme.gap
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                spacing: Theme.gap

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(implicitWidth, parent.width - appLabel.width - parent.spacing)
                    text: leaf.tl?.title ?? ""
                    elide: Text.ElideRight
                    color: leaf.tl?.wayland === ToplevelManager.activeToplevel ? Config.accent : Config.textPrimary
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontMd
                }

                Text {
                    id: appLabel

                    anchors.verticalCenter: parent.verticalCenter
                    text: leaf.entry.appId
                    color: Config.textSecondary
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }
        }
    }
}
