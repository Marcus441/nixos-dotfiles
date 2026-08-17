import QtQuick
import QtQuick.Controls
import qs
import qs.lib
import qs.services

Item {
    id: root

    property var bar

    readonly property int count: Notifs.tracked.length

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    BarWidget {
        id: widget

        text: Notifs.dnd ? "󰂛" : root.count > 0 ? "󰂚" : "󰂜"
        baseColor: !Notifs.dnd && root.count > 0 ? Config.base0D : Config.base03
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
                active: Notifs.dnd
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
            color: Config.base03
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

            delegate: Rectangle {
                id: row

                required property var modelData

                width: list.width
                height: inner.implicitHeight + 12
                color: rowMouse.containsMouse ? Config.base02 : "transparent"

                Column {
                    id: inner

                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    anchors.right: dismissBtn.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Row {
                        spacing: 8

                        Text {
                            text: row.modelData.summary !== "" ? row.modelData.summary : row.modelData.appName
                            color: Config.base05
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize
                        }

                        Text {
                            visible: row.modelData.summary !== "" && row.modelData.appName !== ""
                            text: row.modelData.appName
                            color: Config.base04
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize - 2
                            topPadding: 1
                        }
                    }

                    Text {
                        visible: row.modelData.body !== ""
                        width: inner.width
                        text: row.modelData.body
                        textFormat: Text.PlainText
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        color: Config.base04
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }
                }

                Text {
                    id: dismissBtn

                    anchors.right: parent.right
                    anchors.rightMargin: 14
                    anchors.verticalCenter: parent.verticalCenter
                    text: "󰅖"
                    color: rowMouse.containsMouse ? Config.base08 : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                MouseArea {
                    id: rowMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: row.modelData.dismiss()
                }
            }
        }
    }
}
