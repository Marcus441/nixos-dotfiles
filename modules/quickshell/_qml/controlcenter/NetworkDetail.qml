pragma ComponentBehavior: Bound
import Quickshell.Networking
import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    width: parent ? parent.width : implicitWidth

    Repeater {
        model: NetworkService.knownNetworks.slice(0, 8)

        PopupRow {
            id: netRow

            required property WifiNetwork modelData

            onClicked: {
                if (!netRow.modelData)
                    return;
                if (netRow.modelData.connected)
                    netRow.modelData.disconnect();
                else
                    netRow.modelData.connect();
            }

            Text {
                text: NetworkService.signalIcon(netRow.modelData?.signalStrength ?? 0)
                color: netRow.modelData?.connected ? Config.base0D : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
            }

            Text {
                text: netRow.modelData?.name ?? ""
                color: netRow.modelData?.connected ? Config.base05 : Config.base04
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }
    }

    PopupRow {
        hoverable: false
        visible: NetworkService.knownNetworks.length === 0

        Text {
            text: NetworkService.wifiEnabled ? "no known networks in range" : "wi-fi is off"
            color: Config.base04
            font.family: Config.fontFamily
            font.pixelSize: Theme.fontSm
        }
    }
}
