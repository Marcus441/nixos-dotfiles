import Quickshell
import QtQuick
import qs
import qs.lib

BarWidget {
    property var bar

    text: "󰤆"
    baseColor: Config.base08
    onClicked: bar.shell.togglePower()
    onRightClicked: {
        if (Config.lockCommand !== "")
            Quickshell.execDetached([Config.sh, "-c", Config.lockCommand]);
    }
}
