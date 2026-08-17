import QtQuick
import qs
import qs.services

Text {
    text: LayoutState.monocle ? "" : "󰙀"
    color: LayoutState.monocle ? Config.base0D : Config.base04
    font.family: Config.iconFamily
    font.pixelSize: Config.fontSize
}
