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
        const hours = Math.floor(total / 3600);
        const mins = Math.floor(total / 60) % 60;
        const secs = total % 60;
        const pad = n => n < 10 ? `0${n}` : `${n}`;
        return hours > 0 ? `${hours}:${pad(mins)}:${pad(secs)}` : `${mins}:${pad(secs)}`;
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

        Visualiser {
            id: viz

            anchors.verticalCenter: parent.verticalCenter
            node: AudioService.sink
            active: MediaService.isPlaying
            fill: MediaService.isPlaying ? Config.base0D : Config.base03
            implicitHeight: Math.round(Config.fontSize * 0.85)
        }

        Item {
            id: titleClip

            readonly property bool overflowing: metrics.advanceWidth > width
            readonly property real span: metrics.advanceWidth + marquee.spacing
            readonly property bool rolling: stripMouse.containsMouse && overflowing

            visible: !root.vertical && root.label !== ""
            width: root.titleWidth
            height: still.implicitHeight
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

            TextMetrics {
                id: metrics

                font: still.font
                text: root.label
            }

            Row {
                id: marquee

                visible: titleClip.rolling
                height: titleClip.height
                spacing: Theme.pad * 2

                Repeater {
                    model: 2

                    Text {
                        width: metrics.advanceWidth
                        height: titleClip.height
                        verticalAlignment: Text.AlignVCenter
                        text: still.text
                        color: still.color
                        font: still.font
                    }
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
                    to: -titleClip.span
                    duration: titleClip.span * 18
                }
            }
        }
    }

    MouseArea {
        id: stripMouse

        anchors.fill: strip
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

    Timer {
        running: popup.visible && MediaService.seekable && MediaService.isPlaying
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
        onVisibleChanged: {
            if (popup.visible)
                MediaService.refreshPosition();
        }

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

            readonly property int stampWidth: MediaService.length >= 3600 ? 62 : 44
            readonly property real fraction: seekRow.scrub >= 0 ? seekRow.scrub : MediaService.length > 0 ? Math.min(1, MediaService.position / MediaService.length) : 0

            property real scrub: -1

            function abortScrub(): void {
                settle.stop();
                seekRow.scrub = -1;
            }

            visible: MediaService.seekable
            width: parent.width
            implicitHeight: elapsed.implicitHeight + 12

            Connections {
                target: MediaService

                function onActiveChanged(): void {
                    seekRow.abortScrub();
                }

                function onTitleChanged(): void {
                    seekRow.abortScrub();
                }
            }

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
                text: root.clock(seekRow.scrub >= 0 ? seekRow.scrub * MediaService.length : MediaService.position)
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

            Meter {
                anchors.left: elapsed.right
                anchors.right: total.left
                anchors.leftMargin: Theme.gap
                anchors.rightMargin: Theme.gap
                anchors.verticalCenter: parent.verticalCenter
                value: seekRow.fraction
                interactive: true
                onMoved: fraction => {
                    settle.stop();
                    seekRow.scrub = Math.max(0, Math.min(1, fraction));
                }
                onReleased: {
                    if (seekRow.scrub < 0)
                        return;
                    MediaService.seekTo(seekRow.scrub * MediaService.length);
                    settle.restart();
                }
                onCanceled: seekRow.scrub = -1
            }
        }

        Item {
            width: parent.width
            implicitHeight: play.implicitHeight + 12

            TextAction {
                visible: MediaService.canGoBack
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

                onClicked: MediaService.pick(playerRow.modelData === MediaService.picked ? null : playerRow.modelData)

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

                Text {
                    visible: playerRow.modelData === MediaService.picked
                    text: "󰐃"
                    color: Config.base0D
                    font.family: Config.iconFamily
                    font.pixelSize: Theme.fontSm
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
