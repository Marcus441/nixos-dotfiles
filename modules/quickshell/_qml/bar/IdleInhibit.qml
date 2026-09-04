import Quickshell.Wayland
import QtQuick
import qs
import qs.lib

BarWidget {
    id: root

    required property Bar bar
    property bool active: false

    text: active ? "󰅶" : "󰛊"
    baseColor: active ? Config.base0A : Config.textMuted
    onClicked: active = !active

    IdleInhibitor {
        window: root.bar
        enabled: root.active
    }
}
