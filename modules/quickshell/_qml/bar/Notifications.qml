pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import qs
import qs.lib
import qs.services

Item {
    id: root

    readonly property int count: Notifs.tracked.length

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    BarWidget {
        id: widget

        text: Notifs.dnd ? "󰂛" : root.count > 0 ? "󰂚" : "󰂜"
        baseColor: !Notifs.dnd && root.count > 0 ? Config.accent : Config.textMuted
        onClicked: popup.visible = !popup.visible
        onRightClicked: Notifs.dnd = !Notifs.dnd
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Notifications"
        visible: false

        headerContent: [
            TextAction {
                text: "󰂛 dnd"
                toggled: Notifs.dnd
                onTriggered: Notifs.dnd = !Notifs.dnd
            },
            TextAction {
                visible: root.count > 0
                text: "󰆴 clear"
                onTriggered: Notifs.clearAll()
            }
        ]

        Text {
            visible: root.count === 0
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: "No notifications"
            color: Config.textMuted
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
        }

        ListView {
            id: list

            visible: root.count > 0
            width: parent.width
            implicitWidth: 380
            implicitHeight: Math.min(contentHeight, 400)
            clip: true
            model: Notifs.tracked.slice().reverse()

            ScrollBar.vertical: ThinScrollBar {}

            delegate: PopupRow {
                id: row

                required property var modelData

                onClicked: row.modelData.dismiss()

                Column {
                    id: stack

                    width: row.width - dismissBtn.width - Theme.pad * 2 - Theme.gap
                    spacing: 2

                    Row {
                        spacing: Theme.gap

                        Text {
                            text: row.modelData.summary !== "" ? row.modelData.summary : row.modelData.appName
                            color: Config.textPrimary
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize
                        }

                        Text {
                            visible: row.modelData.summary !== "" && row.modelData.appName !== ""
                            text: row.modelData.appName
                            color: Config.textSecondary
                            font.family: Config.fontFamily
                            font.pixelSize: Theme.fontSm
                            topPadding: 1
                        }
                    }

                    Text {
                        visible: row.modelData.body !== ""
                        width: stack.width
                        text: row.modelData.body
                        textFormat: Text.PlainText
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        color: Config.textSecondary
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }
                }

                trailing: Text {
                    id: dismissBtn

                    text: "󰅖"
                    color: row.hovered ? Config.base08 : Config.textSecondary
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durFast
                        }
                    }
                }
            }
        }
    }
}
