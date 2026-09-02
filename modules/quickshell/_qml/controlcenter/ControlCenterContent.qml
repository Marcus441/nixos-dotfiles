import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    signal dismissRequested

    required property var host

    readonly property real innerWidth: width - leftPadding - rightPadding

    width: parent ? parent.width : implicitWidth
    spacing: Theme.gap
    leftPadding: Theme.gap
    rightPadding: Theme.gap
    bottomPadding: Theme.gap

    CompoundPill {
        width: root.innerWidth
        iconName: {
            if (NetworkService.wifiConnected)
                return NetworkService.signalIcon(NetworkService.wifiSignalStrength);
            if (NetworkService.ethernetConnected)
                return "󱘖";
            return "󰤮";
        }
        isActive: NetworkService.wifiEnabled
        expanded: root.host.expandedSection === "wifi"
        primaryText: "Wi-Fi"
        secondaryText: {
            if (NetworkService.wifiConnected)
                return NetworkService.currentWifiSSID;
            if (NetworkService.ethernetConnected)
                return "ethernet";
            return NetworkService.wifiEnabled ? "not connected" : "off";
        }
        onToggled: NetworkService.toggleWifiRadio()
        onExpandClicked: root.host.toggleSection("wifi")
    }

    NetworkDetail {
        width: root.innerWidth
        visible: root.host.expandedSection === "wifi"
    }

    CompoundPill {
        width: root.innerWidth
        visible: BluetoothService.available
        iconName: !BluetoothService.enabled ? "󰂲" : BluetoothService.connected ? "󰂱" : "󰂯"
        isActive: BluetoothService.enabled
        expanded: root.host.expandedSection === "bluetooth"
        primaryText: "Bluetooth"
        secondaryText: {
            if (!BluetoothService.enabled)
                return "off";
            const names = BluetoothService.connectedDevices.map(d => d.name);
            return names.length > 0 ? names.join(", ") : "on";
        }
        onToggled: BluetoothService.setBluetoothEnabled(!BluetoothService.enabled)
        onExpandClicked: root.host.toggleSection("bluetooth")
    }

    BluetoothDetail {
        width: root.innerWidth
        visible: BluetoothService.available && root.host.expandedSection === "bluetooth"
    }

    CompoundPill {
        width: root.innerWidth
        iconName: AudioService.muted ? "󰖁" : AudioService.volume >= 0.66 ? "󰕾" : AudioService.volume >= 0.33 ? "󰖀" : "󰕿"
        isActive: !AudioService.muted
        expanded: root.host.expandedSection === "audio"
        primaryText: "Audio"
        secondaryText: AudioService.sink ? `${AudioService.displayName(AudioService.sink)}  ${Math.round(AudioService.volume * 100)}%` : "no sink"
        onToggled: AudioService.toggleMute()
        onExpandClicked: root.host.toggleSection("audio")
        onWheelEvent: wheel => AudioService.setVolume(AudioService.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))
    }

    AudioDetail {
        width: root.innerWidth
        visible: root.host.expandedSection === "audio"
        onDismissRequested: root.dismissRequested()
    }
}
