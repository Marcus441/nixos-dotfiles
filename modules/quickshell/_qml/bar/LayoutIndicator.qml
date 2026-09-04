import QtQuick
import qs
import qs.services

Text {
    text: LayoutState.monocle ? "" : "󰙀"
    color: LayoutState.monocle ? Config.accent : Config.textMuted
    font.family: Config.iconFamily
    font.pixelSize: Config.fontSize
}
