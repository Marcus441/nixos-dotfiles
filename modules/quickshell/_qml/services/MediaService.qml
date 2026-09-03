pragma Singleton
pragma ComponentBehavior: Bound
import QtQml
import Quickshell
import Quickshell.Services.Mpris
import qs.lib

Singleton {
    id: root

    property MprisPlayer picked: null
    property MprisPlayer recent: null
    property real heldLength: 0

    onReportedLengthChanged: {
        if (root.reportedLength > 1)
            root.heldLength = root.reportedLength;
    }
    onTitleChanged: {
        if (root.title !== "")
            root.heldLength = 0;
    }
    onActiveChanged: root.heldLength = 0

    readonly property var players: {
        playerWatch.rev;
        return Mpris.players.values.filter(p => p.canControl);
    }

    readonly property MprisPlayer active: {
        const list = root.players;
        if (list.length === 0)
            return null;
        if (root.picked && list.indexOf(root.picked) >= 0)
            return root.picked;
        const playing = list.filter(p => p.playbackState === MprisPlaybackState.Playing);
        if (playing.length > 0)
            return playing[0];
        if (root.recent && list.indexOf(root.recent) >= 0)
            return root.recent;
        return list[0];
    }

    readonly property bool hasPlayer: root.active !== null
    readonly property bool isPlaying: root.active?.playbackState === MprisPlaybackState.Playing
    readonly property string title: root.active?.trackTitle ?? ""
    readonly property string artist: root.active?.trackArtist ?? ""
    readonly property string album: root.active?.trackAlbum ?? ""
    readonly property string artUrl: root.active?.trackArtUrl ?? ""
    readonly property real reportedLength: (root.active?.lengthSupported ?? false) ? root.active.length : 0
    readonly property real length: root.heldLength > 1 ? root.heldLength : root.reportedLength
    readonly property real position: root.active?.position ?? 0
    readonly property bool canSeek: (root.active?.canSeek ?? false) && (root.active?.positionSupported ?? false)
    readonly property bool seekable: root.canSeek && root.length > 1
    readonly property bool canGoNext: root.active?.canGoNext ?? false
    readonly property bool canGoPrevious: root.active?.canGoPrevious ?? false
    readonly property bool canRaise: root.active?.canRaise ?? false
    readonly property bool shuffleSupported: root.active?.shuffleSupported ?? false
    readonly property bool shuffle: root.active?.shuffle ?? false
    readonly property bool loopSupported: root.active?.loopSupported ?? false

    readonly property string repeatMode: {
        switch (root.active?.loopState) {
        case MprisLoopState.Track:
            return "track";
        case MprisLoopState.Playlist:
            return "playlist";
        default:
            return "none";
        }
    }

    function isPlayerPlaying(player: MprisPlayer): bool {
        return player?.playbackState === MprisPlaybackState.Playing;
    }

    function pick(player: MprisPlayer): void {
        root.picked = player;
    }

    function playPause(): void {
        if (root.active?.canTogglePlaying)
            root.active.togglePlaying();
    }

    function next(): void {
        if (root.canGoNext)
            root.active.next();
    }

    function previous(): void {
        if (root.canGoPrevious)
            root.active.previous();
    }

    function stop(): void {
        if (root.active)
            root.active.stop();
    }

    function raise(): void {
        if (root.canRaise)
            root.active.raise();
    }

    function seekTo(seconds: real): void {
        if (root.seekable)
            root.active.position = Math.max(0, Math.min(seconds, root.length));
    }

    function refreshPosition(): void {
        if (root.active)
            root.active.positionChanged();
    }

    function toggleShuffle(): void {
        if (root.shuffleSupported)
            root.active.shuffle = !root.active.shuffle;
    }

    function cycleRepeat(): void {
        if (!root.loopSupported)
            return;
        if (root.repeatMode === "none")
            root.active.loopState = MprisLoopState.Playlist;
        else if (root.repeatMode === "playlist")
            root.active.loopState = MprisLoopState.Track;
        else
            root.active.loopState = MprisLoopState.None;
    }

    ModelWatcher {
        id: playerWatch

        model: Mpris.players
    }

    Instantiator {
        model: root.players

        delegate: QtObject {
            id: entry

            required property MprisPlayer modelData

            readonly property Connections conn: Connections {
                target: entry.modelData

                function onPlaybackStateChanged(): void {
                    if (root.isPlayerPlaying(entry.modelData))
                        root.recent = entry.modelData;
                }
            }
        }
    }
}
