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
    color: Qt.rgba(0, 0, 0, 0.4)

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.dismissed()
    }

    Rectangle {
        id: panel

        anchors.centerIn: parent
        width: root.contentWidth
        height: root.contentHeight
        color: Config.base00

        MouseArea {
            anchors.fill: parent
        }
    }
}
