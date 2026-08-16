import Quickshell
import Quickshell.Io
import QtQuick
import qs
import qs.lib

Overlay {
    id: root

    contentWidth: 560
    contentHeight: 420

    property var entries: []
    property var filtered: []
    property int selected: 0

    function refilter() {
        const q = search.text.toLowerCase();
        filtered = q === "" ? entries : entries.filter(e => e.text.toLowerCase().includes(q));
        selected = 0;
    }

    function pick(entry) {
        if (!entry)
            return;
        Quickshell.execDetached([Config.sh, "-c", `${Config.cliphist} decode ${entry.id} | ${Config.wlCopy}`]);
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
                root.refilter();
            }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        TextInput {
            id: search

            width: parent.width
            color: Config.base05
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize + 4
            focus: true
            onTextChanged: root.refilter()
            Keys.onEscapePressed: root.dismissed()
            Keys.onUpPressed: root.selected = Math.max(0, root.selected - 1)
            Keys.onDownPressed: root.selected = Math.min(root.filtered.length - 1, root.selected + 1)
            Keys.onReturnPressed: root.pick(root.filtered[root.selected])

            Text {
                visible: search.text === ""
                text: "Clipboard history…"
                color: Config.base03
                font: search.font
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: Config.base02
        }

        ListView {
            id: list

            width: parent.width
            height: parent.height - search.height - 21
            clip: true
            model: root.filtered
            currentIndex: root.selected
            highlightMoveDuration: 80

            delegate: Item {
                id: row

                required property var modelData
                required property int index

                width: list.width
                height: 28

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: row.index === root.selected ? Config.base02 : "transparent"
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    width: parent.width - 16
                    text: row.modelData.text
                    elide: Text.ElideRight
                    color: Config.base05
                    font.family: Config.monoFamily
                    font.pixelSize: Config.fontSize
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.selected = row.index
                    onClicked: root.pick(row.modelData)
                }
            }
        }
    }
}
