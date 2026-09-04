import QtQuick
import qs

Rectangle {
    id: root

    signal toggled
    signal expandClicked
    signal wheelEvent(var wheel)
    signal meterMoved(real fraction)

    property string iconName: ""
    property bool isActive: false
    property bool expanded: false
    property bool showExpandArea: true
    property bool hoverable: true
    property string primaryText: ""
    property string secondaryText: ""
    property color accentColor: Config.accent
    property real meterValue: -1
    property color meterColor: Config.accent
    property bool meterInteractive: false
    property real subMeterValue: -1
    property color subMeterColor: Config.textMuted
    property string subMeterLabel: ""

    readonly property bool hasMeter: root.meterValue >= 0
    readonly property bool hasSubMeter: root.subMeterValue >= 0

    width: parent ? parent.width : 220
    height: Math.max(48, bodyColumn.implicitHeight + 18)
    radius: 8
    color: root.hoverable && (pillMouse.containsMouse || tileMouse.containsMouse) ? Config.selection : Config.chrome

    Behavior on color {
        ColorAnimation {
            duration: Theme.durFast
        }
    }

    MouseArea {
        id: pillMouse

        anchors.fill: parent
        enabled: root.hoverable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showExpandArea ? root.expandClicked() : root.toggled()
        onWheel: wheel => root.wheelEvent(wheel)
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
            color: root.isActive ? root.accentColor : Config.base08

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durFast
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.iconName
                color: Config.base00
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
            }

            MouseArea {
                id: tileMouse

                anchors.fill: parent
                enabled: root.hoverable
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.toggled()
                onWheel: wheel => root.wheelEvent(wheel)
            }
        }

        Item {
            id: body

            width: row.width - iconTile.width - row.spacing - row.anchors.leftMargin - row.anchors.rightMargin - (chevron.visible ? chevron.width + row.spacing : 0)
            height: row.height

            Column {
                id: bodyColumn

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                Text {
                    width: parent.width
                    text: root.primaryText
                    color: Config.textPrimary
                    elide: Text.ElideRight
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    width: parent.width
                    text: root.secondaryText
                    visible: text.length > 0
                    color: Config.textSecondary
                    elide: Text.ElideRight
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontSm
                }

                Meter {
                    id: meterTrack

                    visible: root.hasMeter
                    width: parent.width
                    value: root.meterValue
                    fill: root.meterColor
                    interactive: root.meterInteractive
                    onMoved: fraction => root.meterMoved(fraction)
                }

                Text {
                    width: parent.width
                    text: root.subMeterLabel
                    visible: root.hasSubMeter && text.length > 0
                    color: Config.textSecondary
                    elide: Text.ElideRight
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontSm
                }

                Meter {
                    id: subMeterTrack

                    visible: root.hasSubMeter
                    width: parent.width
                    value: root.subMeterValue
                    fill: root.subMeterColor
                }
            }
        }

        Text {
            id: chevron

            visible: root.showExpandArea
            anchors.verticalCenter: parent.verticalCenter
            text: root.expanded ? "󰅀" : "󰅂"
            color: pillMouse.containsMouse ? Config.textPrimary : Config.textSecondary
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
