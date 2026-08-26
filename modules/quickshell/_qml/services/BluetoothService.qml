pragma Singleton
import Quickshell
import Quickshell.Bluetooth
import qs.lib

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool enabled: adapter?.enabled ?? false

    readonly property bool connected: {
        devWatch.rev;
        return Bluetooth.devices.values.some(d => d.connected);
    }
    readonly property var connectedDevices: {
        devWatch.rev;
        return Bluetooth.devices.values.filter(d => d.connected);
    }

    function setBluetoothEnabled(en: bool): void {
        if (adapter)
            adapter.enabled = en;
    }

    ModelWatcher {
        id: devWatch

        model: Bluetooth.devices
    }
}
