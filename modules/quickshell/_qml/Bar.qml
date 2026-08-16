import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.bar

PanelWindow {
    id: bar

    property var shell
    readonly property bool vertical: Config.barPosition === "left" || Config.barPosition === "right"

    anchors {
        left: Config.barPosition !== "right"
        right: Config.barPosition !== "left"
        top: Config.barPosition !== "bottom"
        bottom: Config.barPosition !== "top"
    }

    implicitHeight: 26
    implicitWidth: 30
    color: Config.base00

    Rectangle {
        color: Config.base01
        anchors.left: parent.left
        anchors.right: Config.barPosition === "left" ? undefined : parent.right
        anchors.top: parent.top
        anchors.bottom: Config.barPosition === "top" ? undefined : parent.bottom
        width: bar.vertical ? 1 : parent.width
        height: bar.vertical ? parent.height : 1
    }

    GridLayout {
        id: startGroup

        flow: bar.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: 8
        columnSpacing: 8
        anchors.left: bar.vertical ? undefined : parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: bar.vertical ? undefined : parent.verticalCenter
        anchors.top: bar.vertical ? parent.top : undefined
        anchors.topMargin: 8
        anchors.horizontalCenter: bar.vertical ? parent.horizontalCenter : undefined

        Workspaces {
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
        rowSpacing: 8
        columnSpacing: 8
        anchors.right: bar.vertical ? undefined : parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: bar.vertical ? undefined : parent.verticalCenter
        anchors.bottom: bar.vertical ? parent.bottom : undefined
        anchors.bottomMargin: 8
        anchors.horizontalCenter: bar.vertical ? parent.horizontalCenter : undefined

        Tray {
            bar: bar
        }

        Perf {
            bar: bar
        }

        Wifi {
            bar: bar
        }

        Bluetooth {
            bar: bar
        }

        Volume {
            bar: bar
        }

        IdleInhibit {
            bar: bar
        }

        Battery {}

        WallpaperButton {
            bar: bar
        }

        Power {}
    }
}
