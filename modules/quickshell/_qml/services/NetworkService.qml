pragma Singleton
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property var wifiDevice: {
        const wifis = Networking.devices.values.filter(d => d.type === DeviceType.Wifi);
        return wifis.find(d => d.connected) ?? wifis[0] ?? null;
    }
    readonly property var ethernetDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired) ?? null
    readonly property bool ethernetConnected: ethernetDevice?.connected ?? false

    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property var activeNetwork: wifiDevice?.networks.values.find(n => n.connected) ?? null
    readonly property bool wifiConnected: activeNetwork !== null
    readonly property string currentWifiSSID: activeNetwork?.name ?? ""
    readonly property real wifiSignalStrength: activeNetwork?.signalStrength ?? 0

    readonly property string networkStatus: {
        if (wifiConnected)
            return "wifi";
        if (ethernetConnected)
            return "ethernet";
        return "disconnected";
    }

    readonly property var knownNetworks: (wifiDevice?.networks.values ?? []).filter(n => n.known).sort((a, b) => b.signalStrength - a.signalStrength)

    function toggleWifiRadio(): void {
        Networking.wifiEnabled = !Networking.wifiEnabled;
    }

    function signalIcon(strength: real): string {
        const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
        return icons[Math.min(4, Math.floor(strength * 5))];
    }
}
