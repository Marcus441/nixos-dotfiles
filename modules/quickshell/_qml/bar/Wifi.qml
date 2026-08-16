import Quickshell
import Quickshell.Networking
import QtQuick
import qs
import qs.lib

Item {
    id: root

    property var bar
    property int devRev: 0

    readonly property var wifiDev: {
        devRev;
        return Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null;
    }
    readonly property var wiredDev: {
        devRev;
        return Networking.devices.values.find(d => d.type === DeviceType.Wired) ?? null;
    }
    readonly property var activeNet: {
        devRev;
        return wifiDev?.networks.values.find(n => n.connected) ?? null;
    }

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    function strengthIcon(strength) {
        const icons = ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"];
        return icons[Math.min(4, Math.floor(strength / 20))];
    }

    Connections {
        target: Networking.devices

        function onObjectInsertedPost() {
            root.devRev++;
        }

        function onObjectRemovedPost() {
            root.devRev++;
        }
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
        visible: false

        Column {
            spacing: 6

            Row {
                spacing: 12

                Text {
                    text: Networking.wifiEnabled ? "󰤨 wifi on" : "󰤮 wifi off"
                    color: toggleMouse.containsMouse ? Config.base0D : Config.base05
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        id: toggleMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
                    }
                }

                Text {
                    visible: Config.networkManagerCommand !== ""
                    text: "󱂬 manager"
                    color: managerMouse.containsMouse ? Config.base0D : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        id: managerMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.networkManagerCommand}`]);
                            popup.visible = false;
                        }
                    }
                }
            }

            Repeater {
                model: {
                    root.devRev;
                    return (root.wifiDev?.networks.values ?? []).slice().sort((a, b) => b.signalStrength - a.signalStrength).slice(0, 10);
                }

                Row {
                    id: netRow

                    required property var modelData

                    spacing: 8

                    Text {
                        text: root.strengthIcon(netRow.modelData.signalStrength)
                        color: netRow.modelData.connected ? Config.base0D : Config.base04
                        font.family: Config.iconFamily
                        font.pixelSize: Config.fontSize
                    }

                    Text {
                        text: netRow.modelData.name + (netRow.modelData.security !== WifiSecurityType.Open ? " 󰌾" : "")
                        color: netMouse.containsMouse ? Config.base0D : netRow.modelData.connected ? Config.base05 : Config.base04
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize

                        MouseArea {
                            id: netMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (netRow.modelData.connected)
                                    netRow.modelData.disconnect();
                                else if (netRow.modelData.known || netRow.modelData.security === WifiSecurityType.Open)
                                    netRow.modelData.connect();
                                else if (Config.networkManagerCommand !== "")
                                    Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.networkManagerCommand}`]);
                            }
                        }
                    }
                }
            }
        }
    }
}
