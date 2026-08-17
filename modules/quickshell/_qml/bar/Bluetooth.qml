import Quickshell
import Quickshell.Bluetooth
import QtQuick
import qs
import qs.lib

Item {
    id: root

    property var bar
    property int devRev: 0

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool anyConnected: {
        devRev;
        return Bluetooth.devices.values.some(d => d.connected);
    }

    visible: adapter !== null
    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    Connections {
        target: Bluetooth.devices

        function onObjectInsertedPost() {
            root.devRev++;
        }

        function onObjectRemovedPost() {
            root.devRev++;
        }
    }

    BarWidget {
        id: widget

        text: !root.adapter?.enabled ? "󰂲" : root.anyConnected ? "󰂱" : "󰂯"
        baseColor: root.anyConnected ? Config.base0D : Config.base03
        onClicked: popup.visible = !popup.visible
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Bluetooth"
        visible: false

        headerContent: [
            TextAction {
                text: root.adapter?.enabled ? "󰂯 on" : "󰂲 off"
                active: root.adapter?.enabled ?? false
                onTriggered: {
                    if (root.adapter)
                        root.adapter.enabled = !root.adapter.enabled;
                }
            },
            TextAction {
                text: "󱂬 manager"
                onTriggered: {
                    Quickshell.execDetached([Config.sh, "-c", "uwsm app -- blueman-manager"]);
                    popup.visible = false;
                }
            }
        ]

        Repeater {
            model: {
                root.devRev;
                return Bluetooth.devices.values.filter(d => d.paired).slice(0, 10);
            }

            PopupRow {
                id: devRow

                required property var modelData

                onClicked: {
                    if (devRow.modelData.connected)
                        devRow.modelData.disconnect();
                    else
                        devRow.modelData.connect();
                }

                Text {
                    text: {
                        const battery = devRow.modelData.batteryAvailable ? `  ${Math.round(devRow.modelData.battery * 100)}%` : "";
                        return `${devRow.modelData.connected ? "󰂱" : "󰂯"} ${devRow.modelData.name}${battery}`;
                    }
                    color: devRow.modelData.connected ? Config.base05 : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                }
            }
        }
    }
}
