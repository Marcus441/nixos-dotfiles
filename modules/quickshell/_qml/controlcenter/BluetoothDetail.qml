pragma ComponentBehavior: Bound
import Quickshell.Bluetooth
import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    width: parent ? parent.width : implicitWidth

    Repeater {
        model: BluetoothService.pairedDevices.slice(0, 8)

        PopupRow {
            id: devRow

            required property BluetoothDevice modelData

            onClicked: {
                if (!devRow.modelData)
                    return;
                if (devRow.modelData.connected)
                    devRow.modelData.disconnect();
                else
                    devRow.modelData.connect();
            }

            Text {
                text: {
                    if (!devRow.modelData)
                        return "";
                    const battery = devRow.modelData.batteryAvailable ? `  ${Math.round(devRow.modelData.battery * 100)}%` : "";
                    return `${devRow.modelData.connected ? "󰂱" : "󰂯"} ${devRow.modelData.name}${battery}`;
                }
                color: devRow.modelData?.connected ? Config.base05 : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
            }
        }
    }

    PopupRow {
        hoverable: false
        visible: BluetoothService.pairedDevices.length === 0

        Text {
            text: "no paired devices"
            color: Config.base04
            font.family: Config.fontFamily
            font.pixelSize: Theme.fontSm
        }
    }
}
