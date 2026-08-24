pragma ComponentBehavior: Bound
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs
import qs.lib

Row {
    id: root

    property var openMenu: null

    spacing: Theme.gap
    visible: SystemTray.items.values.length > 0

    function toggleMenu(popup) {
        if (root.openMenu && root.openMenu !== popup)
            root.openMenu.visible = false;
        popup.visible = !popup.visible;
        root.openMenu = popup.visible ? popup : null;
    }

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
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouseEvent => {
                    if (mouseEvent.button === Qt.LeftButton && !item.modelData.onlyMenu)
                        item.modelData.activate();
                    else if (item.modelData.hasMenu)
                        root.toggleMenu(menu);
                }
            }

            BarPopup {
                id: menu

                anchorItem: item
                minWidth: 160
                visible: false

                MenuList {
                    handle: menu.visible ? item.modelData.menu : null
                    onActivated: menu.visible = false
                }
            }
        }
    }
}
