pragma ComponentBehavior: Bound
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import qs
import qs.lib

Row {
    id: root

    property var openMenu: null
    property bool expanded: false

    spacing: Theme.gap
    visible: SystemTray.items.values.length > 0

    function toggleMenu(popup) {
        if (root.openMenu && root.openMenu !== popup)
            root.openMenu.visible = false;
        popup.visible = !popup.visible;
        root.openMenu = popup.visible ? popup : null;
    }

    Text {
        id: chevron

        anchors.verticalCenter: parent.verticalCenter
        text: root.expanded ? "󰅂" : "󰅁"
        color: chevronMouse.containsMouse ? Config.base05 : Config.base03
        font.family: Config.iconFamily
        font.pixelSize: Config.fontSize

        Behavior on color {
            ColorAnimation {
                duration: Theme.durFast
            }
        }

        MouseArea {
            id: chevronMouse

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.expanded = !root.expanded;
                if (!root.expanded && root.openMenu) {
                    root.openMenu.visible = false;
                    root.openMenu = null;
                }
            }
        }
    }

    Item {
        id: drawer

        clip: true
        width: root.expanded ? icons.implicitWidth : 0
        height: icons.implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        visible: width > 0

        Behavior on width {
            NumberAnimation {
                duration: Theme.durMed
                easing.type: Easing.InOutQuad
            }
        }

        Row {
            id: icons

            spacing: Theme.gap

            Repeater {
                model: SystemTray.items

                IconImage {
                    id: item

                    required property var modelData

                    source: modelData.icon
                    implicitSize: 14

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
    }
}
