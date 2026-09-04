pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
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
    property bool showWidget: true
    property string currentWall: ""
    property bool rotatorEnabled: false
    property string rotatorCategory: ""
    readonly property bool rotatorMatchesView: root.rotatorEnabled && root.rotatorCategory === root.currentCategory

    implicitWidth: root.showWidget ? widget.implicitWidth : 0
    implicitHeight: root.showWidget ? widget.implicitHeight : 0

    onCurrentCategoryChanged: grid.positionViewAtBeginning()

    function toggle() {
        popup.visible = !popup.visible;
    }

    function revealCurrent() {
        const i = (grid.model ?? []).findIndex(w => w.path === root.currentWall);
        if (i >= 0)
            grid.positionViewAtIndex(i, GridView.Center);
    }

    function pick(path) {
        Quickshell.execDetached([Config.setWallpaperScript, path]);
        root.currentWall = path;
        root.rotatorEnabled = false;
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
        id: currentCheck

        command: [Config.sh, "-c", `readlink "${Config.cacheDir}/current_wallpaper.img"`]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.currentWall = text.trim()
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

        visible: root.showWidget
        text: "󰸉"
        baseColor: root.rotatorEnabled ? Config.base0B : Config.textMuted
        onClicked: popup.visible = !popup.visible
    }

    BarPopup {
        id: popup

        anchorItem: root
        title: "Wallpapers"
        visible: false
        onVisibleChanged: {
            if (visible) {
                rotatorCheck.running = true;
                currentCheck.running = true;
                Qt.callLater(root.revealCurrent);
            } else
                root.currentCategory = "";
        }

        headerContent: [
            TextAction {
                text: root.rotatorEnabled ? "󰒝 shuffle: " + (root.rotatorCategory || "all") : "󰒝 shuffle off"
                toggled: root.rotatorMatchesView
                onTriggered: root.toggleRotator()
            }
        ]

        Row {
            id: panes

            rightPadding: 4

            ListView {
                id: sidebar

                width: 170
                height: 400
                clip: true
                model: root.sidebarModel

                ScrollBar.vertical: ThinScrollBar {}

                delegate: PopupRow {
                    id: catRow

                    required property var modelData

                    readonly property bool selected: catRow.modelData.all ? root.currentCategory === "" : root.currentCategory === catRow.modelData.name

                    highlighted: catRow.selected
                    onClicked: root.currentCategory = catRow.modelData.all ? "" : catRow.modelData.name

                    trailing: Text {
                        text: catRow.modelData.count
                        color: Config.textMuted
                        font.family: Config.fontFamily
                        font.pixelSize: Theme.fontSm
                    }

                    Text {
                        text: catRow.modelData.name
                        elide: Text.ElideRight
                        color: catRow.selected || catRow.hovered ? Config.textPrimary : Config.textSecondary
                        font.family: Config.fontFamily
                        font.pixelSize: Config.fontSize
                    }
                }
            }

            Rectangle {
                width: 1
                height: sidebar.height
                color: Config.chrome
            }

            GridView {
                id: grid

                width: 480
                height: 400
                clip: true
                cellWidth: width / 3
                cellHeight: 104
                model: root.current ? root.current.walls : root.allWalls

                ScrollBar.vertical: ThinScrollBar {}

                delegate: Item {
                    id: cell

                    required property var modelData

                    readonly property bool isCurrent: cell.modelData.path === root.currentWall

                    width: grid.cellWidth
                    height: grid.cellHeight

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        ClippingRectangle {
                            width: parent.width
                            height: parent.height - label.height - parent.spacing
                            radius: Theme.radius
                            color: "transparent"
                            border.width: cell.isCurrent ? 2 : cellMouse.containsMouse ? 1 : 0
                            border.color: cell.isCurrent ? Config.accent : Config.textSecondary
                            opacity: cell.isCurrent || cellMouse.containsMouse ? 1 : 0.82

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Theme.durFast
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source: "file://" + cell.modelData.thumb
                                sourceSize.width: 240
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                            }
                        }

                        Text {
                            id: label

                            width: parent.width
                            text: (cell.modelData.category ? cell.modelData.category + " / " : "") + cell.modelData.name.replace(/[_-]/g, " ")
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            color: cell.isCurrent ? Config.accent : cellMouse.containsMouse ? Config.textPrimary : Config.textSecondary
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
