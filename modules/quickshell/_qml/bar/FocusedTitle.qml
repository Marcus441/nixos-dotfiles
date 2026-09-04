import Quickshell.Wayland
import QtQuick
import qs

Text {
    readonly property string title: ToplevelManager.activeToplevel?.title ?? ""

    text: title.length > 30 ? title.slice(0, 29) + "…" : title
    color: Config.textMuted
    font.family: Config.fontFamily
    font.pixelSize: Config.fontSize
}
