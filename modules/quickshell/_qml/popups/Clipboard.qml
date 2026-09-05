pragma ComponentBehavior: Bound
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    WlrLayershell.namespace: "quickshell-clipboard"

    property var entries: []
    property int restoreIndex: 0

    function pick(entry) {
        if (!entry)
            return;
        Config.launch(`${Config.cliphist} decode ${entry.id} | ${Config.wlCopy}`);
        root.dismissed();
    }

    function remove(entry) {
        if (!entry || deleteProc.running)
            return;
        root.restoreIndex = filterList.selected;
        deleteProc.entryId = entry.id;
        deleteProc.stdinEnabled = true;
        deleteProc.running = true;
    }

    Process {
        id: deleteProc

        property string entryId: ""

        command: [Config.cliphist, "delete"]
        // cliphist delete takes the entry on stdin, not as an argument, and an
        // id and a tab are the whole of what it matches on
        onStarted: {
            deleteProc.write(`${deleteProc.entryId}\t`);
            deleteProc.stdinEnabled = false;
        }
        onExited: listProc.running = true
    }

    Process {
        id: listProc

        command: [Config.cliphist, "list"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                // cliphist prints one binary preview, `[[ binary data <size>
                // <type> <W>x<H> ]]`; anything else it prints is text
                const binary = /^\[\[ binary data (.+) (\S+) (\d+x\d+) \]\]$/;
                root.entries = text.split("\n").filter(line => line !== "").map(line => {
                    const tab = line.indexOf("\t");
                    const body = line.slice(tab + 1);
                    const shape = binary.exec(body);
                    return {
                        id: line.slice(0, tab),
                        text: body,
                        image: shape !== null,
                        size: shape ? shape[1] : "",
                        format: shape ? shape[2] : "",
                        dims: shape ? shape[3] : "",
                        search: body.toLowerCase()
                    };
                });
                filterList.refilter();
                // refilter reseeds the cursor to 0, which after a delete would
                // throw it to the top of the list rather than leave it in place
                filterList.selected = Math.max(0, Math.min(filterList.filtered.length - 1, root.restoreIndex));
                root.restoreIndex = 0;
            }
        }
    }

    PointerGuard {
        id: hoverGuard
    }

    FilterList {
        id: filterList

        anchors.fill: parent
        placeholder: "Clipboard history…"
        emptyText: filterList.query === "" ? "Clipboard is empty" : "No matches"
        searchIcon: "󰍉"
        searchPixelSize: Theme.fontXl
        deleteKeys: true
        filterFn: q => q === "" ? root.entries : root.entries.filter(e => e.search.includes(q))
        onDismissed: root.dismissed()
        onAccepted: root.pick(filterList.filtered[filterList.selected])
        onDeleted: root.remove(filterList.filtered[filterList.selected])

        delegate: Item {
            id: row

            required property var modelData
            required property int index

            width: filterList.rowWidth
            height: Theme.rowText

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

            Text {
                visible: !row.modelData.image
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                width: parent.width - Theme.pad * 2 - (kill.visible ? kill.width + Theme.gap : 0)
                text: row.modelData.text
                elide: Text.ElideRight
                color: Config.textPrimary
                font.family: Config.monoFamily
                font.pixelSize: Config.fontSize
            }

            Row {
                visible: row.modelData.image
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                spacing: Theme.gap

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰋩"
                    color: Config.accent
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: row.modelData.dims
                    color: Config.accent
                    font.family: Config.monoFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: `${row.modelData.format}  ${row.modelData.size}`
                    color: Config.textMuted
                    font.family: Config.monoFamily
                    font.pixelSize: Config.fontSize
                }
            }

            MouseArea {
                id: rowMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPositionChanged: mouse => {
                    const p = row.mapToItem(null, mouse.x, mouse.y);
                    if (hoverGuard.moved(p.x, p.y))
                        filterList.selected = row.index;
                }
                onClicked: root.pick(row.modelData)
            }

            Text {
                id: kill

                visible: rowMouse.containsMouse || row.index === filterList.selected
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                text: "󰅖"
                color: killMouse.containsMouse ? Config.base08 : Config.textMuted
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize

                Behavior on color {
                    ColorAnimation {
                        duration: Theme.durFast
                    }
                }

                // the glyph is a small target on a 28px row, so the hit area is
                // the row's full height and a gap wider than the mark
                MouseArea {
                    id: killMouse

                    anchors.centerIn: parent
                    width: parent.width + Theme.gap * 2
                    height: row.height
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.remove(row.modelData)
                }
            }
        }
    }
}
