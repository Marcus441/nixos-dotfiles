pragma ComponentBehavior: Bound
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    WlrLayershell.namespace: "quickshell-clipboard"

    // the list keeps the width every other modal has; the pane is additive, so
    // no row is narrower here than it is in the launcher
    contentWidth: Theme.modalWidth + Theme.previewWidth

    property var entries: []
    property int restoreIndex: 0
    readonly property int decodeCap: 65536

    function decode(entry) {
        decodeProc.running = false;
        root.body = "";
        // never decode an image into a string: the bytes are not text
        if (!entry || entry.image)
            return;
        decodeProc.command = [Config.sh, "-c", `${Config.cliphist} decode ${entry.id} | ${Config.head} -c ${root.decodeCap}`];
        decodeProc.running = true;
    }

    property string body: ""

    Process {
        id: decodeProc

        stdout: StdioCollector {
            onStreamFinished: root.body = text
        }
    }

    Timer {
        id: decodeDebounce

        interval: 120
        onTriggered: root.decode(preview.entry)
    }

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

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Theme.modalWidth
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

    Rectangle {
        id: paneEdge

        anchors.left: filterList.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Theme.border
        color: Config.chrome
    }

    Item {
        id: preview

        readonly property var entry: filterList.filtered[filterList.selected] ?? null

        anchors.left: paneEdge.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: Theme.pad

        onEntryChanged: decodeDebounce.restart()

        Text {
            id: previewLabel

            anchors.top: parent.top
            anchors.left: parent.left
            text: "Preview"
            color: Config.textMuted
            font.family: Config.fontFamily
            font.pixelSize: Theme.fontSm
        }

        Item {
            id: previewBody

            anchors.top: previewLabel.bottom
            anchors.topMargin: Theme.gap
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: previewFoot.top
            anchors.bottomMargin: Theme.gap
            clip: true

            Text {
                id: previewText

                anchors.fill: parent
                text: preview.entry?.image ? `${preview.entry.dims}  ${preview.entry.format}  ${preview.entry.size}` : root.body
                textFormat: Text.PlainText
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                color: preview.entry?.image ? Config.accent : Config.textSecondary
                font.family: Config.monoFamily
                font.pixelSize: Config.fontSize
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 36
                visible: previewText.truncated

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: Qt.rgba(Config.card.r, Config.card.g, Config.card.b, 0)
                    }

                    GradientStop {
                        position: 1.0
                        color: Config.card
                    }
                }
            }
        }

        Text {
            id: previewFoot

            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            elide: Text.ElideRight
            text: {
                if (!preview.entry)
                    return "";
                if (preview.entry.image)
                    return `image · ${preview.entry.size}`;
                const chars = root.body.length;
                const lines = root.body.split("\n").length;
                const shape = `${chars} chars, ${lines} lines`;
                return previewText.truncated ? `… truncated · ${shape} total` : shape;
            }
            color: previewText.truncated ? Config.base0A : Config.textMuted
            font.family: Config.monoFamily
            font.pixelSize: Theme.fontSm
        }
    }
}
