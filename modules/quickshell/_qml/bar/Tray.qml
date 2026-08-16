import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs

Row {
    id: root

    property var bar

    spacing: 8
    visible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items

        IconImage {
            id: item

            required property var modelData

            source: modelData.icon
            implicitSize: 14
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouseEvent => {
                    if (mouseEvent.button === Qt.LeftButton && !item.modelData.onlyMenu)
                        item.modelData.activate();
                    else
                        item.modelData.display(root.bar, item.x + mouseEvent.x, root.bar.vertical ? item.y + mouseEvent.y : root.bar.implicitHeight);
                }
            }
        }
    }
}
