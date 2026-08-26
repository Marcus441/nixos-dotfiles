import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    signal dismissRequested

    function strengthIcon(strength) {
        const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
        return icons[Math.min(4, Math.floor(strength * 5))];
    }

    width: parent ? parent.width : implicitWidth
    spacing: Theme.gap
    leftPadding: Theme.gap
    rightPadding: Theme.gap
    bottomPadding: Theme.gap

    CompoundPill {
        width: root.width - root.leftPadding - root.rightPadding
        iconName: {
            if (NetworkService.wifiConnected)
                return root.strengthIcon(NetworkService.wifiSignalStrength);
            if (NetworkService.ethernetConnected)
                return "󱘖";
            return "󰤮";
        }
        isActive: NetworkService.wifiEnabled
        primaryText: "Wi-Fi"
        secondaryText: {
            if (NetworkService.wifiConnected)
                return NetworkService.currentWifiSSID;
            if (NetworkService.ethernetConnected)
                return "ethernet";
            return NetworkService.wifiEnabled ? "not connected" : "off";
        }
        onToggled: NetworkService.toggleWifiRadio()
    }

    CompoundPill {
        width: root.width - root.leftPadding - root.rightPadding
        visible: BluetoothService.available
        iconName: !BluetoothService.enabled ? "󰂲" : BluetoothService.connected ? "󰂱" : "󰂯"
        isActive: BluetoothService.enabled
        primaryText: "Bluetooth"
        secondaryText: {
            if (!BluetoothService.enabled)
                return "off";
            const names = BluetoothService.connectedDevices.map(d => d.name);
            return names.length > 0 ? names.join(", ") : "on";
        }
        onToggled: BluetoothService.setBluetoothEnabled(!BluetoothService.enabled)
    }

    CompoundPill {
        width: root.width - root.leftPadding - root.rightPadding
        iconName: AudioService.muted ? "󰖁" : AudioService.volume >= 0.66 ? "󰕾" : AudioService.volume >= 0.33 ? "󰖀" : "󰕿"
        isActive: !AudioService.muted
        primaryText: "Audio"
        secondaryText: AudioService.sink ? `${AudioService.displayName(AudioService.sink)}  ${Math.round(AudioService.volume * 100)}%` : "no sink"
        onToggled: AudioService.toggleMute()
        onWheelEvent: wheel => AudioService.setVolume(AudioService.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    }

    Row {
        spacing: Theme.gap

        Rectangle {
            id: track

            width: 220
            height: 6
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            color: Config.base02

            Rectangle {
                width: track.width * Math.min(AudioService.volume, 1)
                height: parent.height
                radius: 3
                color: AudioService.muted ? Config.base08 : Config.base0D
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onPressed: mouseEvent => AudioService.setVolume(mouseEvent.x / track.width)
                onPositionChanged: mouseEvent => {
                    if (pressed)
                        AudioService.setVolume(mouseEvent.x / track.width);
                }
            }
        }

        TextAction {
            visible: Config.audioMixerCommand !== ""
            text: "󰓃"
            anchors.verticalCenter: parent.verticalCenter
            onTriggered: {
                Config.launchApp(Config.audioMixerCommand);
                root.dismissRequested();
            }
        }
    }
}
