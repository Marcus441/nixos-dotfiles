import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

PanelWindow {
    id: root

    signal dismissed

    property int contentWidth: Theme.modalWidth
    property int contentHeight: Theme.modalHeight
    default property alias content: panel.data

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore
    color: Config.scrim

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
        color: Config.card
        radius: Theme.radius
        border.width: Theme.border
        border.color: Config.chrome

        MouseArea {
            anchors.fill: parent
        }
    }
}
