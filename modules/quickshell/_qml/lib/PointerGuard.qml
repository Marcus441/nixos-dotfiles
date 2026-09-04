import QtQuick

QtObject {
    id: root

    property real lastX: 0
    property real lastY: 0
    property bool seen: false

    // a surface mapping under a still pointer draws a Wayland enter plus
    // motion, which Qt reports as a hover; only a real move may select
    function moved(x: real, y: real): bool {
        const changed = root.seen && (root.lastX !== x || root.lastY !== y);
        root.lastX = x;
        root.lastY = y;
        root.seen = true;
        return changed;
    }
}
