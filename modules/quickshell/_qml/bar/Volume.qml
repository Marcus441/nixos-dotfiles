import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import qs
import qs.lib

Item {
    id: root

    property var bar
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    function setVolume(value) {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, value));
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    BarWidget {
        id: widget

        text: root.muted ? "󰖁" : root.volume >= 0.66 ? "󰕾" : root.volume >= 0.33 ? "󰖀" : "󰕿"
        baseColor: root.muted ? Config.base08 : Config.base03
        onClicked: popup.visible = !popup.visible
        onRightClicked: {
            if (root.sink?.audio)
                root.sink.audio.muted = !root.sink.audio.muted;
        }
        onScrolled: delta => root.setVolume(root.volume + (delta > 0 ? 0.05 : -0.05))
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Volume"
        visible: false

        headerContent: [
            Text {
                text: root.muted ? "󰖁 unmute" : "󰕾 mute"
                color: muteMouse.containsMouse ? Config.base0D : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize

                MouseArea {
                    id: muteMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.sink?.audio)
                            root.sink.audio.muted = !root.sink.audio.muted;
                    }
                }
            },
            Text {
                text: "󰓃 mixer"
                color: mixerMouse.containsMouse ? Config.base0D : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize

                MouseArea {
                    id: mixerMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached([Config.sh, "-c", "uwsm app -- pavucontrol"]);
                        popup.visible = false;
                    }
                }
            }
        ]

        PopupRow {
            hoverable: false

            Text {
                text: `${root.sink?.description ?? "No sink"}  ${Math.round(root.volume * 100)}%`
                color: Config.base05
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }
        }

        PopupRow {
            hoverable: false

            Rectangle {
                id: track

                width: 220
                height: 6
                radius: 3
                color: Config.base02

                Rectangle {
                    width: track.width * Math.min(root.volume, 1)
                    height: parent.height
                    radius: 3
                    color: root.muted ? Config.base08 : Config.base0D
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    cursorShape: Qt.PointingHandCursor
                    onPressed: mouseEvent => root.setVolume(mouseEvent.x / track.width)
                    onPositionChanged: mouseEvent => {
                        if (pressed)
                            root.setVolume(mouseEvent.x / track.width);
                    }
                }
            }
        }
    }
}
