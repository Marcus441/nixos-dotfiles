pragma ComponentBehavior: Bound
import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    signal dismissRequested

    width: parent ? parent.width : implicitWidth

    Repeater {
        model: AudioService.sinks

        PopupRow {
            id: sinkRow

            required property PwNode modelData

            readonly property bool current: sinkRow.modelData === AudioService.sink

            onClicked: {
                if (sinkRow.modelData)
                    AudioService.setSink(sinkRow.modelData);
            }

            Text {
                text: "󰓃"
                color: sinkRow.current ? Config.accent : Config.textSecondary
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
            }

            Text {
                text: AudioService.displayName(sinkRow.modelData)
                color: sinkRow.current ? Config.textPrimary : Config.textSecondary
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }
    }

    PopupRow {
        hoverable: false
        visible: AudioService.sinks.length === 0

        Text {
            text: "no outputs"
            color: Config.textSecondary
            font.family: Config.fontFamily
            font.pixelSize: Theme.fontSm
        }
    }

    PopupRow {
        visible: Config.audioMixerCommand !== ""
        onClicked: {
            Config.launchApp(Config.audioMixerCommand);
            root.dismissRequested();
        }

        Text {
            text: "󰘮"
            color: Config.textSecondary
            font.family: Config.iconFamily
            font.pixelSize: Config.fontSize
        }

        Text {
            text: "mixer"
            color: Config.textSecondary
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
        }
    }
}
