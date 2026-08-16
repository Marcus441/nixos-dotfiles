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
        visible: false

        Column {
            spacing: 6

            Row {
                spacing: 12

                Text {
                    text: root.adapter?.enabled ? "󰂯 bluetooth on" : "󰂲 bluetooth off"
                    color: toggleMouse.containsMouse ? Config.base0D : Config.base05
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        id: toggleMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (root.adapter)
                                root.adapter.enabled = !root.adapter.enabled;
                        }
                    }
                }

                Text {
                    text: "󱂬 manager"
                    color: managerMouse.containsMouse ? Config.base0D : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        id: managerMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            Quickshell.execDetached([Config.sh, "-c", "uwsm app -- blueman-manager"]);
                            popup.visible = false;
                        }
                    }
                }
            }

            Repeater {
                model: {
                    root.devRev;
                    return Bluetooth.devices.values.filter(d => d.paired).slice(0, 10);
                }

                Text {
                    id: devRow

                    required property var modelData

                    text: {
                        const battery = devRow.modelData.batteryAvailable ? `  ${Math.round(devRow.modelData.battery * 100)}%` : "";
                        return `${devRow.modelData.connected ? "󰂱" : "󰂯"} ${devRow.modelData.name}${battery}`;
                    }
                    color: devMouse.containsMouse ? Config.base0D : devRow.modelData.connected ? Config.base05 : Config.base04
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize

                    MouseArea {
                        id: devMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (devRow.modelData.connected)
                                devRow.modelData.disconnect();
                            else
                                devRow.modelData.connect();
                        }
                    }
                }
            }
        }
    }
}
