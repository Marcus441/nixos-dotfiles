pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.lib

ColumnLayout {
    id: root

    property var handle: null
    property int depth: 0

    signal activated

    spacing: 0

    QsMenuOpener {
        id: opener

        menu: root.handle
    }

    Repeater {
        model: opener.children

        ColumnLayout {
            id: entry

            required property var modelData
            property bool expanded: false

            Layout.fillWidth: true
            spacing: 0

            Item {
                visible: entry.modelData.isSeparator
                implicitHeight: Theme.gap
                Layout.fillWidth: true

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: Theme.pad
                    anchors.rightMargin: Theme.pad
                    height: 1
                    color: Config.chrome
                }
            }

            Item {
                visible: !entry.modelData.isSeparator
                implicitWidth: row.implicitWidth
                implicitHeight: row.implicitHeight
                Layout.fillWidth: true

                PopupRow {
                    id: row

                    hoverable: entry.modelData.enabled
                    onClicked: {
                        if (entry.modelData.hasChildren) {
                            entry.expanded = !entry.expanded;
                            return;
                        }
                        entry.modelData.triggered();
                        root.activated();
                    }

                    Item {
                        visible: root.depth > 0
                        width: root.depth * Theme.pad
                        height: 1
                    }

                    Text {
                        visible: entry.modelData.buttonType !== QsMenuButtonType.None
                        text: {
                            const checked = entry.modelData.checkState === Qt.Checked;
                            if (entry.modelData.buttonType === QsMenuButtonType.RadioButton)
                                return checked ? "󰐾" : "󰐽";
                            return checked ? "󰄲" : "󰄱";
                        }
                        color: entry.modelData.enabled ? Config.accent : Config.textMuted
                        font.family: Config.iconFamily
                        font.pixelSize: Config.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    IconImage {
                        visible: entry.modelData.icon !== ""
                        source: entry.modelData.icon
                        implicitSize: Config.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: entry.modelData.text
                        color: entry.modelData.enabled ? Config.textPrimary : Config.textMuted
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        visible: entry.modelData.hasChildren
                        text: entry.expanded ? "󰅀" : "󰅂"
                        color: Config.textSecondary
                        font.family: Config.iconFamily
                        font.pixelSize: Config.fontSize
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Loader {
                id: submenu

                active: entry.expanded
                visible: entry.expanded
                source: "MenuList.qml"
                Layout.fillWidth: true

                onLoaded: {
                    submenu.item.handle = entry.modelData;
                    submenu.item.depth = root.depth + 1;
                    // qmllint disable missing-property
                    submenu.item.activated.connect(root.activated);
                    // qmllint enable missing-property
                }
            }
        }
    }
}
