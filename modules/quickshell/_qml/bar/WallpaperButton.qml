import QtQuick
import qs
import qs.lib

BarWidget {
    property var bar

    text: "󰸉"
    onClicked: bar.shell.toggleWallpaper()
}
