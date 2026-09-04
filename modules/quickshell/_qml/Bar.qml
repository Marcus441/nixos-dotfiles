import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.bar

PanelWindow {
    id: bar

    readonly property bool vertical: Config.barPosition === "left" || Config.barPosition === "right"

    anchors {
        left: Config.barPosition !== "right"
        right: Config.barPosition !== "left"
        top: Config.barPosition !== "bottom"
        bottom: Config.barPosition !== "top"
    }

    implicitHeight: Config.fontSize + Theme.pad
    implicitWidth: Config.fontSize + Theme.pad + 4
    color: Config.base00

    Rectangle {
        color: Config.chrome
        anchors.left: parent.left
        anchors.right: Config.barPosition === "left" ? undefined : parent.right
        anchors.top: parent.top
        anchors.bottom: Config.barPosition === "top" ? undefined : parent.bottom
        width: bar.vertical ? 1 : parent.width
        height: bar.vertical ? parent.height : 1
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: wallpaperPicker.toggle()
    }

    GridLayout {
        id: startGroup

        flow: bar.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: Theme.gap
        columnSpacing: Theme.gap
        anchors.left: bar.vertical ? undefined : parent.left
        anchors.leftMargin: Theme.gap
        anchors.verticalCenter: bar.vertical ? undefined : parent.verticalCenter
        anchors.top: bar.vertical ? parent.top : undefined
        anchors.topMargin: Theme.gap
        anchors.horizontalCenter: bar.vertical ? parent.horizontalCenter : undefined

        LayoutIndicator {
            Layout.alignment: Qt.AlignHCenter
        }

        Workspaces {
            Layout.alignment: Qt.AlignHCenter
            bar: bar
        }

        FocusedTitle {
            visible: !bar.vertical
        }
    }

    ClockWeather {
        anchors.centerIn: parent
        vertical: bar.vertical
    }

    GridLayout {
        id: endGroup

        flow: bar.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: 20
        columnSpacing: 20
        anchors.right: bar.vertical ? undefined : parent.right
        anchors.rightMargin: Theme.gap
        anchors.verticalCenter: bar.vertical ? undefined : parent.verticalCenter
        anchors.bottom: bar.vertical ? parent.bottom : undefined
        anchors.bottomMargin: Theme.gap
        anchors.horizontalCenter: bar.vertical ? parent.horizontalCenter : undefined

        Media {
            Layout.alignment: Qt.AlignHCenter
            vertical: bar.vertical
        }

        Tray {
            Layout.alignment: Qt.AlignHCenter
        }

        Perf {
            Layout.alignment: Qt.AlignHCenter
        }

        GridLayout {
            id: statusGroup

            Layout.alignment: Qt.AlignHCenter
            flow: endGroup.flow
            rowSpacing: Theme.gap
            columnSpacing: Theme.gap

            ControlCenter {
                Layout.alignment: Qt.AlignHCenter
            }

            Battery {
                Layout.alignment: Qt.AlignHCenter
            }
        }

        GridLayout {
            id: actionGroup

            Layout.alignment: Qt.AlignHCenter
            flow: endGroup.flow
            rowSpacing: Theme.gap
            columnSpacing: Theme.gap

            Notifications {
                Layout.alignment: Qt.AlignHCenter
            }

            IdleInhibit {
                Layout.alignment: Qt.AlignHCenter
                bar: bar
            }
        }

        Power {
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Wallpaper {
        id: wallpaperPicker

        showWidget: false
        anchors.right: bar.vertical ? undefined : parent.right
        anchors.rightMargin: Theme.pad
        anchors.verticalCenter: bar.vertical ? undefined : parent.verticalCenter
        anchors.bottom: bar.vertical ? parent.bottom : undefined
        anchors.horizontalCenter: bar.vertical ? parent.horizontalCenter : undefined
    }
}
