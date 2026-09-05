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

    function pick(entry) {
        if (!entry)
            return;
        Config.launch(`${Config.cliphist} decode ${entry.id} | ${Config.wlCopy}`);
        root.dismissed();
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
        filterFn: q => q === "" ? root.entries : root.entries.filter(e => e.search.includes(q))
        onDismissed: root.dismissed()
        onAccepted: root.pick(filterList.filtered[filterList.selected])

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
                width: parent.width - Theme.pad * 2
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
        }
    }
}
