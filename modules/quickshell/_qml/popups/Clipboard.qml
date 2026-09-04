pragma ComponentBehavior: Bound
import Quickshell.Io
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    contentWidth: 560
    contentHeight: 420

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
                root.entries = text.split("\n").filter(line => line !== "").slice(0, 100).map(line => {
                    const tab = line.indexOf("\t");
                    return {
                        id: line.slice(0, tab),
                        text: line.slice(tab + 1)
                    };
                });
                filterList.refilter();
            }
        }
    }

    FilterList {
        id: filterList

        anchors.fill: parent
        placeholder: "Clipboard history…"
        emptyText: filterList.query === "" ? "Clipboard is empty" : "No matches"
        filterFn: q => q === "" ? root.entries : root.entries.filter(e => e.text.toLowerCase().includes(q))
        onDismissed: root.dismissed()
        onAccepted: root.pick(filterList.filtered[filterList.selected])

        delegate: Item {
            id: row

            required property var modelData
            required property int index

            width: filterList.width
            height: Theme.rowText

            Rectangle {
                anchors.fill: parent
                color: row.index === filterList.selected ? Config.selection : "transparent"
            }

            Text {
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

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: filterList.selected = row.index
                onClicked: root.pick(row.modelData)
            }
        }
    }
}
