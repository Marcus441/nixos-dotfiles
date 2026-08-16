import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

PanelWindow {
    id: root

    signal dismissed

    property int contentWidth: 600
    property int contentHeight: 420
    default property alias content: panel.data

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.dismissed()
    }

    Rectangle {
        id: panel

        anchors.centerIn: parent
        width: root.contentWidth
        height: root.contentHeight
        color: Config.base00
        border.color: Config.base02
        border.width: 1
        radius: 8

        MouseArea {
            anchors.fill: parent
        }
    }
}
