pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import qs

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property real volume: sink?.audio?.volume ?? 0

    function setVolume(value: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, value));
            feedback.running = true;
        }
    }

    function toggleMute(): void {
        if (sink?.audio)
            sink.audio.muted = !sink.audio.muted;
    }

    function displayName(node: PwNode): string {
        if (!node)
            return "";
        return node.description || node.nickname || node.name || "";
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Process {
        id: feedback

        command: [Config.volumeSoundScript]
    }
}
