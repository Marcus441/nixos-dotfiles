import Quickshell
import Quickshell.Networking
import QtQuick
import qs
import qs.lib

Item {
    id: root

    property var bar

    readonly property var wifiDev: {
        const wifis = Networking.devices.values.filter(d => d.type === DeviceType.Wifi);
        return wifis.find(d => d.connected) ?? wifis[0] ?? null;
    }
    readonly property var wiredDev: Networking.devices.values.find(d => d.type === DeviceType.Wired) ?? null
    readonly property var activeNet: wifiDev?.networks.values.find(n => n.connected) ?? null

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    function strengthIcon(strength) {
        const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
        return icons[Math.min(4, Math.floor(strength * 5))];
    }

    BarWidget {
        id: widget

        text: {
            if (root.activeNet)
                return root.strengthIcon(root.activeNet.signalStrength);
            if (root.wiredDev?.connected)
                return "󱘖";
            return "󰤮";
        }
        baseColor: root.activeNet || root.wiredDev?.connected ? Config.base03 : Config.base08
        onClicked: {
            popup.visible = !popup.visible;
            if (root.wifiDev)
                root.wifiDev.scannerEnabled = popup.visible;
        }
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Wi-Fi"
        visible: false

        headerContent: [
            TextAction {
                text: Networking.wifiEnabled ? "󰤨 on" : "󰤮 off"
                active: Networking.wifiEnabled
                onTriggered: Networking.wifiEnabled = !Networking.wifiEnabled
            },
            TextAction {
                visible: Config.networkManagerCommand !== ""
                text: "󱂬 manager"
                onTriggered: {
                    Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.networkManagerCommand}`]);
                    popup.visible = false;
                }
            }
        ]

        Repeater {
            model: (root.wifiDev?.networks.values ?? []).slice().sort((a, b) => b.signalStrength - a.signalStrength).slice(0, 10)

            PopupRow {
                id: netRow

                required property var modelData

                onClicked: {
                    if (netRow.modelData.connected)
                        netRow.modelData.disconnect();
                    else if (netRow.modelData.known || netRow.modelData.security === WifiSecurityType.Open)
                        netRow.modelData.connect();
                    else if (Config.networkManagerCommand !== "")
                        Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.networkManagerCommand}`]);
                }

                Text {
                    text: root.strengthIcon(netRow.modelData.signalStrength)
                    color: netRow.modelData.connected ? Config.base0D : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    text: netRow.modelData.name + (netRow.modelData.security !== WifiSecurityType.Open ? " 󰌾" : "")
                    color: netRow.modelData.connected ? Config.base05 : Config.base04
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }
        }
    }
}
