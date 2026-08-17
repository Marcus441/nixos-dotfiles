import QtQuick
import qs
import qs.lib
import qs.services

BarWidget {
    text: "󰤆"
    baseColor: Config.base08
    onClicked: Popups.toggle("powermenu")
    onRightClicked: {
        if (Config.lockCommand !== "")
            Config.launch(Config.lockCommand);
    }
}
