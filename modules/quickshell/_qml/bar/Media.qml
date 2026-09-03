pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.Mpris
import qs
import qs.lib
import qs.services

Item {
    id: root

    property bool vertical: false

    readonly property int titleWidth: 180
    readonly property string label: MediaService.artist !== "" ? `${MediaService.title} · ${MediaService.artist}` : MediaService.title

    function clock(seconds: real): string {
        const total = Math.max(0, Math.floor(seconds));
        const mins = Math.floor(total / 60);
        const secs = total % 60;
        return `${mins}:${secs < 10 ? "0" : ""}${secs}`;
    }

    visible: MediaService.hasPlayer
    implicitWidth: strip.implicitWidth
    implicitHeight: strip.implicitHeight
    onVisibleChanged: {
        if (!visible)
            popup.visible = false;
    }

    Row {
        id: strip

        spacing: Theme.gap

        BarWidget {
            id: glyph

            text: MediaService.isPlaying ? "󰐊" : "󰏤"
            baseColor: MediaService.isPlaying ? Config.base0D : Config.base03
            onClicked: popup.visible = !popup.visible
            onRightClicked: MediaService.playPause()
            onScrolled: delta => delta > 0 ? MediaService.previous() : MediaService.next()
        }

        Item {
            id: titleClip

            readonly property bool overflowing: lead.implicitWidth > width
            readonly property bool rolling: (titleMouse.containsMouse || glyph.hover) && overflowing

            visible: !root.vertical && root.label !== ""
            width: root.titleWidth
            height: glyph.implicitHeight
            clip: true

            Text {
                id: still

                visible: !titleClip.rolling
                width: titleClip.width
                height: titleClip.height
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: root.label
                color: MediaService.isPlaying ? Config.base05 : Config.base04
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize
            }

            Row {
                id: marquee

                visible: titleClip.rolling
                height: titleClip.height
                spacing: Theme.pad * 2

                Text {
                    id: lead

                    height: titleClip.height
                    verticalAlignment: Text.AlignVCenter
                    text: root.label
                    color: still.color
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    height: titleClip.height
                    verticalAlignment: Text.AlignVCenter
                    text: root.label
                    color: still.color
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }
            }

            SequentialAnimation {
                running: titleClip.rolling
                loops: Animation.Infinite
                onStopped: marquee.x = 0

                PauseAnimation {
                    duration: Theme.durMed * 4
                }

                NumberAnimation {
                    target: marquee
                    property: "x"
                    from: 0
                    to: -(lead.implicitWidth + marquee.spacing)
                    duration: (lead.implicitWidth + marquee.spacing) * 18
                }
            }

            MouseArea {
                id: titleMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouseEvent => {
                    if (mouseEvent.button === Qt.RightButton)
                        MediaService.playPause();
                    else
                        popup.visible = !popup.visible;
                }
                onWheel: wheelEvent => wheelEvent.angleDelta.y > 0 ? MediaService.previous() : MediaService.next()
            }
        }
    }

    Timer {
        running: popup.visible && MediaService.seekable
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: MediaService.refreshPosition()
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Media"
        minWidth: 320
        visible: false

        headerContent: [
            TextAction {
                visible: MediaService.shuffleSupported
                active: MediaService.shuffle
                text: "󰒟"
                onTriggered: MediaService.toggleShuffle()
            },
            TextAction {
                visible: MediaService.loopSupported
                active: MediaService.repeatMode !== "none"
                text: MediaService.repeatMode === "track" ? "󰑘" : "󰑖"
                onTriggered: MediaService.cycleRepeat()
            },
            TextAction {
                visible: MediaService.canRaise
                text: "󰊓"
                onTriggered: {
                    MediaService.raise();
                    popup.visible = false;
                }
            }
        ]

        PopupRow {
            hoverable: false

            Image {
                id: art

                visible: MediaService.artUrl !== "" && art.status !== Image.Error
                width: 72
                height: 72
                clip: true
                asynchronous: true
                cache: false
                retainWhileLoading: true
                fillMode: Image.PreserveAspectCrop
                sourceSize.width: art.width * Screen.devicePixelRatio
                sourceSize.height: art.height * Screen.devicePixelRatio
                source: MediaService.artUrl
                anchors.verticalCenter: parent.verticalCenter
            }

            Column {
                width: 220
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    width: parent.width
                    elide: Text.ElideRight
                    text: MediaService.title !== "" ? MediaService.title : MediaService.active?.identity ?? ""
                    color: Config.base05
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontMd
                }

                Text {
                    visible: MediaService.artist !== ""
                    width: parent.width
                    elide: Text.ElideRight
                    text: MediaService.artist
                    color: Config.base04
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                }

                Text {
                    visible: MediaService.album !== ""
                    width: parent.width
                    elide: Text.ElideRight
                    text: MediaService.album
                    color: Config.base03
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontSm
                }
            }
        }

        Item {
            id: seekRow

            readonly property int stampWidth: 44
            readonly property real fraction: seekRow.scrub >= 0 ? seekRow.scrub : MediaService.length > 0 ? Math.min(1, MediaService.position / MediaService.length) : 0

            property real scrub: -1

            visible: MediaService.seekable
            width: parent.width
            implicitHeight: elapsed.implicitHeight + 12

            Timer {
                id: settle

                interval: 1200
                onTriggered: {
                    MediaService.refreshPosition();
                    seekRow.scrub = -1;
                }
            }

            Text {
                id: elapsed

                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                anchors.verticalCenter: parent.verticalCenter
                width: seekRow.stampWidth
                elide: Text.ElideRight
                text: root.clock(seekRow.fraction * MediaService.length)
                color: Config.base04
                font.family: Config.fontFamily
                font.pixelSize: Theme.fontSm
            }

            Text {
                id: total

                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                anchors.verticalCenter: parent.verticalCenter
                width: seekRow.stampWidth
                horizontalAlignment: Text.AlignRight
                elide: Text.ElideRight
                text: root.clock(MediaService.length)
                color: Config.base04
                font.family: Config.fontFamily
                font.pixelSize: Theme.fontSm
            }

            Rectangle {
                id: track

                anchors.left: elapsed.right
                anchors.right: total.left
                anchors.leftMargin: Theme.gap
                anchors.rightMargin: Theme.gap
                anchors.verticalCenter: parent.verticalCenter
                height: 6
                radius: 3
                color: Config.base02

                Rectangle {
                    width: track.width * seekRow.fraction
                    height: parent.height
                    radius: 3
                    color: Config.base0D
                }

                MouseArea {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height + 12
                    cursorShape: Qt.PointingHandCursor
                    onPressed: mouseEvent => {
                        settle.stop();
                        seekRow.scrub = Math.max(0, Math.min(1, mouseEvent.x / track.width));
                    }
                    onPositionChanged: mouseEvent => {
                        if (pressed)
                            seekRow.scrub = Math.max(0, Math.min(1, mouseEvent.x / track.width));
                    }
                    onReleased: {
                        MediaService.seekTo(seekRow.scrub * MediaService.length);
                        settle.restart();
                    }
                    onCanceled: seekRow.scrub = -1
                }
            }
        }

        Item {
            width: parent.width
            implicitHeight: play.implicitHeight + 12

            TextAction {
                visible: MediaService.canGoPrevious
                anchors.left: parent.left
                anchors.leftMargin: Theme.pad
                anchors.verticalCenter: parent.verticalCenter
                text: "󰒮"
                font.pixelSize: Theme.fontLg
                onTriggered: MediaService.previous()
            }

            TextAction {
                id: play

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: MediaService.isPlaying ? "󰏤" : "󰐊"
                font.pixelSize: Theme.fontXl
                onTriggered: MediaService.playPause()
            }

            TextAction {
                visible: MediaService.canGoNext
                anchors.right: parent.right
                anchors.rightMargin: Theme.pad
                anchors.verticalCenter: parent.verticalCenter
                text: "󰒭"
                font.pixelSize: Theme.fontLg
                onTriggered: MediaService.next()
            }
        }

        Repeater {
            model: MediaService.players.length > 1 ? MediaService.players : []

            PopupRow {
                id: playerRow

                required property MprisPlayer modelData

                onClicked: MediaService.pick(playerRow.modelData)

                Text {
                    text: MediaService.isPlayerPlaying(playerRow.modelData) ? "󰐊" : "󰏤"
                    color: playerRow.modelData === MediaService.active ? Config.base0D : Config.base03
                    font.family: Config.iconFamily
                    font.pixelSize: Config.fontSize
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    width: 240
                    elide: Text.ElideRight
                    text: playerRow.modelData?.trackTitle ? `${playerRow.modelData.identity} — ${playerRow.modelData.trackTitle}` : playerRow.modelData?.identity ?? ""
                    color: playerRow.modelData === MediaService.active ? Config.base05 : Config.base04
                    font.family: Config.fontFamily
                    font.pixelSize: Config.fontSize
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
