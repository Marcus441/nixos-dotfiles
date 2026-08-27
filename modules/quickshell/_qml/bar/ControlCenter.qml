import QtQuick
import QtQuick.Layouts
import qs
import qs.controlcenter
import qs.services

Item {
    id: root

    readonly property bool vertical: Config.barPosition === "left" || Config.barPosition === "right"

    implicitWidth: grid.implicitWidth
    implicitHeight: grid.implicitHeight

    GridLayout {
        id: grid

        flow: root.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: Theme.gap
        columnSpacing: Theme.gap

        Text {
            id: networkGlyph

            Layout.alignment: Qt.AlignHCenter
            text: {
                if (NetworkService.wifiConnected)
                    return NetworkService.signalIcon(NetworkService.wifiSignalStrength);
                if (NetworkService.ethernetConnected)
                    return "󱘖";
                return "󰤮";
            }
            color: NetworkService.networkStatus === "disconnected" ? Config.base08 : Config.base03
            font.family: Config.iconFamily
            font.pixelSize: Config.fontSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: bluetoothGlyph

            Layout.alignment: Qt.AlignHCenter
            visible: BluetoothService.available
            text: !BluetoothService.enabled ? "󰂲" : BluetoothService.connected ? "󰂱" : "󰂯"
            color: BluetoothService.connected ? Config.base0D : Config.base03
            font.family: Config.iconFamily
            font.pixelSize: Config.fontSize
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: volumeGlyph

            Layout.alignment: Qt.AlignHCenter
            text: AudioService.muted ? "󰖁" : AudioService.volume >= 0.66 ? "󰕾" : AudioService.volume >= 0.33 ? "󰖀" : "󰕿"
            color: AudioService.muted ? Config.base08 : Config.base03
            font.family: Config.iconFamily
            font.pixelSize: Config.fontSize
            verticalAlignment: Text.AlignVCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouseEvent => {
            if (mouseEvent.button === Qt.RightButton) {
                if (grid.childAt(mouseEvent.x, mouseEvent.y) === volumeGlyph)
                    AudioService.toggleMute();
            } else {
                popout.visible = !popout.visible;
            }
        }
        onWheel: wheelEvent => AudioService.setVolume(AudioService.volume + (wheelEvent.angleDelta.y > 0 ? 0.05 : -0.05))
    }

    ControlCenterPopout {
        id: popout

        anchorItem: root
    }
}
