import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs
import qs.services

PanelWindow {
    id: root

    anchors {
        top: true
        right: true
    }

    margins {
        top: 20
        right: 20
    }

    implicitWidth: 420
    implicitHeight: column.implicitHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    Column {
        id: column

        width: parent.width
        spacing: 10

        Repeater {
            model: Notifs.popups

            Rectangle {
                id: card

                required property var modelData
                readonly property color accent: modelData.urgency === NotificationUrgency.Critical ? Config.base08 : modelData.urgency === NotificationUrgency.Low ? Config.base03 : Config.base0D
                readonly property string iconSource: modelData.image !== "" ? modelData.image : modelData.appIcon !== "" ? Quickshell.iconPath(modelData.appIcon, true) : ""

                width: column.width
                height: header.height + bodyBlock.height + actionRow.height
                color: Config.base10

                Timer {
                    interval: Notifs.timeoutFor(card.modelData)
                    running: interval > 0
                    onTriggered: Notifs.removePopup(card.modelData)
                }

                Connections {
                    target: card.modelData

                    function onClosed() {
                        Notifs.removePopup(card.modelData);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const def = card.modelData.actions.find(a => a.identifier === "default");
                        if (def)
                            def.invoke();
                        Notifs.removePopup(card.modelData);
                    }
                }

                Rectangle {
                    width: 2
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: card.accent
                }

                Rectangle {
                    id: header

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 2
                    height: summaryText.implicitHeight + 16
                    color: Config.base01

                    Text {
                        id: summaryText

                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.right: appLabel.left
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: card.modelData.summary !== "" ? card.modelData.summary : card.modelData.appName
                        elide: Text.ElideRight
                        color: Config.base05
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }

                    Text {
                        id: appLabel

                        anchors.right: closeBtn.left
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        text: card.modelData.appName
                        color: Config.base04
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize - 2
                    }

                    Text {
                        id: closeBtn

                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: "󰅖"
                        color: closeMouse.containsMouse ? Config.base08 : Config.base04
                        font.family: Config.iconFamily
                        font.pixelSize: Config.fontSize

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        MouseArea {
                            id: closeMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Notifs.removePopup(card.modelData)
                        }
                    }
                }

                Item {
                    id: bodyBlock

                    anchors.top: header.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 2
                    height: Math.max(bodyText.implicitHeight, icon.visible ? icon.height : 0) + 16

                    IconImage {
                        id: icon

                        visible: card.iconSource !== ""
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        implicitSize: 32
                        source: card.iconSource
                    }

                    Text {
                        id: bodyText

                        anchors.left: icon.visible ? icon.right : parent.left
                        anchors.leftMargin: 12
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: card.modelData.body
                        textFormat: Text.PlainText
                        wrapMode: Text.Wrap
                        maximumLineCount: 3
                        elide: Text.ElideRight
                        color: Config.base04
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }
                }

                Row {
                    id: actionRow

                    readonly property var visibleActions: card.modelData.actions.filter(a => a.identifier !== "default")

                    anchors.top: bodyBlock.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 14
                    height: visibleActions.length > 0 ? implicitHeight + 10 : 0
                    spacing: 14

                    Repeater {
                        model: actionRow.visibleActions

                        Text {
                            id: actionText

                            required property var modelData

                            text: modelData.text
                            color: actionMouse.containsMouse ? Config.base0D : Config.base04
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            MouseArea {
                                id: actionMouse

                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    actionText.modelData.invoke();
                                    Notifs.removePopup(card.modelData);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
