pragma Singleton
import Quickshell
import Quickshell.Io
import qs

Singleton {
    id: root

    property var counts: ({})

    function score(id: string): int {
        return root.counts[id] ?? 0;
    }

    function record(id: string): void {
        const next = Object.assign({}, root.counts);
        next[id] = root.score(id) + 1;
        root.counts = next;
        file.setText(JSON.stringify(next));
    }

    FileView {
        id: file

        path: `${Config.cacheDir}/quickshell/launcher-usage.json`
        printErrors: false

        onLoaded: {
            try {
                const parsed = JSON.parse(file.text());
                if (parsed && typeof parsed === "object")
                    root.counts = parsed;
            } catch (e) {
                root.counts = ({});
            }
        }
    }
}
