import Quickshell
import QtQuick
import qs
import qs.lib

BarWidget {
    visible: Config.powerMenuCommand !== ""
    text: "󰤆"
    baseColor: Config.base08
    onClicked: Quickshell.execDetached([Config.sh, "-c", `uwsm app -- ${Config.powerMenuCommand}`])
    onRightClicked: {
        if (Config.lockCommand !== "")
            Quickshell.execDetached([Config.sh, "-c", Config.lockCommand]);
    }
}
