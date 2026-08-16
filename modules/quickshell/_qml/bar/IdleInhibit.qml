import Quickshell.Wayland
import QtQuick
import qs
import qs.lib

BarWidget {
    id: root

    property var bar
    property bool active: false

    text: active ? "󰅶" : "󰛊"
    baseColor: active ? Config.base0A : Config.base03
    onClicked: active = !active

    IdleInhibitor {
        window: root.bar
        enabled: root.active
    }
}
