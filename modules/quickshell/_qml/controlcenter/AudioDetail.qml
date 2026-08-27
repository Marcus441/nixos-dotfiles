import QtQuick
import qs
import qs.lib
import qs.services

Column {
    id: root

    signal dismissRequested

    width: parent ? parent.width : implicitWidth

    PopupRow {
        hoverable: false

        Rectangle {
            id: track

            width: 220
            height: 6
            radius: 3
            anchors.verticalCenter: parent.verticalCenter
            color: Config.base02

            Rectangle {
                width: track.width * Math.min(AudioService.volume, 1)
                height: parent.height
                radius: 3
                color: AudioService.muted ? Config.base08 : Config.base0D
            }

            MouseArea {
                anchors.fill: parent
                anchors.margins: -6
                cursorShape: Qt.PointingHandCursor
                onPressed: mouseEvent => AudioService.setVolume(mouseEvent.x / track.width)
                onPositionChanged: mouseEvent => {
                    if (pressed)
                        AudioService.setVolume(mouseEvent.x / track.width);
                }
            }
        }

        TextAction {
            visible: Config.audioMixerCommand !== ""
            text: "󰓃"
            anchors.verticalCenter: parent.verticalCenter
            onTriggered: {
                Config.launchApp(Config.audioMixerCommand);
                root.dismissRequested();
            }
        }
    }
}
