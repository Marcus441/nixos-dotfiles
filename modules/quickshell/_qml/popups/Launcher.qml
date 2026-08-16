import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs
import qs.lib

Overlay {
    id: root

    contentWidth: 680
    contentHeight: 500

    readonly property var apps: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    property var filtered: apps
    property int selected: 0

    function refilter() {
        const q = search.text.toLowerCase();
        if (q === "") {
            filtered = apps;
        } else {
            const starts = [];
            const contains = [];
            for (const app of apps) {
                const name = app.name.toLowerCase();
                if (name.startsWith(q))
                    starts.push(app);
                else if (name.includes(q) || (app.comment ?? "").toLowerCase().includes(q))
                    contains.push(app);
            }
            filtered = starts.concat(contains);
        }
        selected = 0;
    }

    function launch(app) {
        if (!app)
            return;
        Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${app.id}.desktop`]);
        root.dismissed();
    }

    Column {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: searchBox

            width: parent.width
            height: search.implicitHeight + 24
            color: Config.base01

            Row {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                Text {
                    id: searchIcon

                    text: "󰍉"
                    color: Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize + 8
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextInput {
                    id: search

                    width: parent.width - parent.spacing - searchIcon.width
                    color: Config.base05
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize + 8
                    focus: true
                    anchors.verticalCenter: parent.verticalCenter
                    onTextChanged: root.refilter()
                    Keys.onEscapePressed: root.dismissed()
                    Keys.onUpPressed: root.selected = Math.max(0, root.selected - 1)
                    Keys.onDownPressed: root.selected = Math.min(root.filtered.length - 1, root.selected + 1)
                    Keys.onReturnPressed: root.launch(root.filtered[root.selected])

                    Text {
                        visible: search.text === ""
                        text: "Search applications…"
                        color: Config.base03
                        font: search.font
                    }
                }
            }
        }

        ListView {
            id: list

            width: parent.width
            height: parent.height - searchBox.height
            topMargin: 8
            bottomMargin: 8
            clip: true
            model: root.filtered
            currentIndex: root.selected
            highlightMoveDuration: 80

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded

                contentItem: Rectangle {
                    implicitWidth: 6
                    color: Config.base02
                }
            }

            delegate: Item {
                id: row

                required property var modelData
                required property int index

                width: list.width
                height: 44

                Rectangle {
                    anchors.fill: parent
                    color: row.index === root.selected ? Config.base02 : "transparent"
                }

                IconImage {
                    id: icon

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    implicitSize: 28
                    asynchronous: true
                    source: Quickshell.iconPath(row.modelData.icon, true)
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: icon.right
                    anchors.leftMargin: 8

                    Text {
                        text: row.modelData.name
                        color: Config.base05
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize + 4
                    }

                    Text {
                        visible: (row.modelData.comment ?? "") !== ""
                        text: row.modelData.comment ?? ""
                        color: Config.base03
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize + 1
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.selected = row.index
                    onClicked: root.launch(row.modelData)
                }
            }
        }
    }
}
