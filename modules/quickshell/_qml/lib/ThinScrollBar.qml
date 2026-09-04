import QtQuick
import QtQuick.Controls
import qs

ScrollBar {
    id: root

    policy: ScrollBar.AsNeeded

    contentItem: Rectangle {
        implicitWidth: 8
        radius: width / 2
        color: Config.textMuted
        opacity: root.active ? 0.6 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.durMed
            }
        }
    }
}
