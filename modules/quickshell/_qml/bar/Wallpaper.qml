pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import qs
import qs.lib

Item {
    id: root

    property var categories: []
    property var allWalls: []
    property string currentCategory: ""
    readonly property var current: root.categories.find(c => c.name === root.currentCategory) ?? null
    readonly property var sidebarModel: [
        {
            name: "All",
            count: root.allWalls.length,
            all: true
        },
        ...root.categories]
    property bool rotatorEnabled: false
    property string rotatorCategory: ""
    readonly property bool rotatorMatchesView: root.rotatorEnabled && root.rotatorCategory === root.currentCategory

    implicitWidth: widget.implicitWidth
    implicitHeight: widget.implicitHeight

    onCurrentCategoryChanged: grid.positionViewAtBeginning()

    function pick(path) {
        Quickshell.execDetached([Config.setWallpaperScript, path]);
        popup.visible = false;
    }

    function toggleRotator() {
        rotatorToggle.command = root.rotatorMatchesView ? [Config.disableRotatorScript] : [Config.enableRotatorScript, root.currentCategory];
        rotatorToggle.running = true;
    }

    FileView {
        path: Config.wallpaperManifest
        onLoaded: {
            const cats = JSON.parse(text()).categories;
            const all = [];
            for (const c of cats) {
                for (const w of c.walls)
                    all.push({
                        category: c.name,
                        name: w.name,
                        path: w.path,
                        thumb: w.thumb
                    });
            }
            root.categories = cats;
            root.allWalls = all;
        }
    }

    Process {
        id: rotatorToggle

        onExited: rotatorCheck.running = true
    }

    Process {
        id: rotatorCheck

        command: [Config.sh, "-c", `cat "${Config.cacheDir}/wallpaper_rotator_enabled" 2>/dev/null`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.rotatorCategory = text.trim()
        }

        onExited: exitCode => root.rotatorEnabled = exitCode === 0
    }

    BarWidget {
        id: widget

        text: "󰸉"
        onClicked: popup.visible = !popup.visible
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Wallpapers"
        visible: false
        onVisibleChanged: {
            if (visible)
                rotatorCheck.running = true;
            else
                root.currentCategory = "";
        }

        headerContent: [
            TextAction {
                text: root.rotatorEnabled ? "󰒝 shuffle: " + (root.rotatorCategory || "all") : "󰒝 shuffle off"
                active: root.rotatorMatchesView
                onTriggered: root.toggleRotator()
            }
        ]

        Row {
            id: panes

            ListView {
                id: sidebar

                width: 150
                height: 460
                clip: true
                model: root.sidebarModel

                ScrollBar.vertical: ThinScrollBar {}

                delegate: Rectangle {
                    id: catRow

                    required property var modelData

                    readonly property bool selected: catRow.modelData.all ? root.currentCategory === "" : root.currentCategory === catRow.modelData.name

                    width: sidebar.width
                    height: catName.implicitHeight + 12
                    color: selected ? Config.base02 : catMouse.containsMouse ? Config.base01 : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durFast
                        }
                    }

                    Text {
                        id: catName

                        anchors.left: parent.left
                        anchors.leftMargin: Theme.pad
                        anchors.right: catCount.left
                        anchors.rightMargin: Theme.gap
                        anchors.verticalCenter: parent.verticalCenter
                        text: catRow.modelData.name
                        elide: Text.ElideRight
                        color: catRow.selected || catMouse.containsMouse ? Config.base05 : Config.base04
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }

                    Text {
                        id: catCount

                        anchors.right: parent.right
                        anchors.rightMargin: Theme.pad
                        anchors.verticalCenter: parent.verticalCenter
                        text: catRow.modelData.count
                        color: Config.base03
                        font.family: Config.fontFamily
                        font.pixelSize: Theme.fontSm
                    }

                    MouseArea {
                        id: catMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.currentCategory = catRow.modelData.all ? "" : catRow.modelData.name
                    }
                }
            }

            Rectangle {
                width: 1
                height: sidebar.height
                color: Config.base01
            }

            GridView {
                id: grid

                width: 480
                height: 460
                clip: true
                cellWidth: width / 3
                cellHeight: 104
                model: root.current ? root.current.walls : root.allWalls

                ScrollBar.vertical: ThinScrollBar {}

                delegate: Item {
                    id: cell

                    required property var modelData

                    width: grid.cellWidth
                    height: grid.cellHeight

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        Image {
                            width: parent.width
                            height: parent.height - label.height - parent.spacing
                            source: "file://" + cell.modelData.thumb
                            sourceSize.width: 240
                            fillMode: Image.PreserveAspectCrop
                            clip: true
                            asynchronous: true
                            opacity: cellMouse.containsMouse ? 1 : 0.82

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Theme.durFast
                                }
                            }
                        }

                        Text {
                            id: label

                            width: parent.width
                            text: (cell.modelData.category ? cell.modelData.category + " / " : "") + cell.modelData.name.replace(/[_-]/g, " ")
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            color: cellMouse.containsMouse ? Config.base05 : Config.base04
                            font.family: Config.fontFamily
                            font.pixelSize: Theme.fontSm
                        }
                    }

                    MouseArea {
                        id: cellMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.pick(cell.modelData.path)
                    }
                }
            }
        }
    }
}
