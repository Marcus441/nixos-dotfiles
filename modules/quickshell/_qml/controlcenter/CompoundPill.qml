import QtQuick
import qs

Rectangle {
    id: root

    signal toggled
    signal expandClicked
    signal wheelEvent(var wheel)

    property string iconName: ""
    property bool isActive: false
    property bool expanded: false
    property bool showExpandArea: true
    property string primaryText: ""
    property string secondaryText: ""

    width: parent ? parent.width : 220
    height: 48
    radius: 8
    color: bodyMouse.containsMouse ? Config.base02 : Config.base01

    Behavior on color {
        ColorAnimation {
            duration: Theme.durFast
        }
    }

    Row {
        id: row

        anchors.fill: parent
        anchors.leftMargin: 6
        anchors.rightMargin: Theme.pad
        spacing: Theme.gap

        Rectangle {
            id: iconTile

            width: 36
            height: 36
            anchors.verticalCenter: parent.verticalCenter
            radius: 6
            color: root.isActive ? Config.base0D : Config.base02

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durFast
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.iconName
                color: root.isActive ? Config.base00 : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
            }

            MouseArea {
                id: tileMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
            }
        }

        Item {
            id: body

            width: row.width - iconTile.width - row.spacing - row.anchors.leftMargin - row.anchors.rightMargin - (chevron.visible ? chevron.width + row.spacing : 0)
            height: row.height

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    width: parent.width
                    text: root.primaryText
                    color: Config.base05
                    elide: Text.ElideRight
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    width: parent.width
                    text: root.secondaryText
                    visible: text.length > 0
                    color: Config.base04
                    elide: Text.ElideRight
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontSm
                }
            }

            MouseArea {
                id: bodyMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.showExpandArea ? root.expandClicked() : root.toggled()
            }
        }

        Text {
            id: chevron

            visible: root.showExpandArea
            width: visible ? implicitWidth : 0
            anchors.verticalCenter: parent.verticalCenter
            text: root.expanded ? "󰅀" : "󰅂"
            color: bodyMouse.containsMouse ? Config.base05 : Config.base04
            font.family: Config.iconFamily
            font.pixelSize: Config.fontSize

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durFast
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: wheel => root.wheelEvent(wheel)
    }
}
