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
    property int selected: 0
    readonly property int columns: 3
    readonly property var filtered: {
        const inCategory = root.currentCategory === "" ? root.allWalls : root.allWalls.filter(w => w.category === root.currentCategory);
        const q = search.text.trim().toLowerCase();
        return q === "" ? inCategory : inCategory.filter(w => w.search.includes(q));
    }
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
    onFilteredChanged: root.selected = 0

    function pick(path) {
        if (!path)
            return;
        Quickshell.execDetached([Config.setWallpaperScript, path]);
        root.rotatorEnabled = false;
        popup.visible = false;
    }

    function move(delta) {
        if (root.filtered.length === 0)
            return;
        root.selected = Math.max(0, Math.min(root.filtered.length - 1, root.selected + delta));
        grid.positionViewAtIndex(root.selected, GridView.Contain);
    }

    function accept() {
        const wall = root.filtered[root.selected];
        if (wall)
            root.pick(wall.path);
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
                        thumb: w.thumb,
                        search: `${c.name} ${w.name}`.replace(/[_-]/g, " ").toLowerCase()
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
                search.focusInput();
            } else {
                root.currentCategory = "";
                search.text = "";
            }
        }

        headerContent: [
            TextAction {
                text: root.rotatorEnabled ? "󰒝 shuffle: " + (root.rotatorCategory || "all") : "󰒝 shuffle off"
                toggled: root.rotatorMatchesView
                onTriggered: root.toggleRotator()
            }
        ]

        Column {
            spacing: Theme.gap

            SearchField {
                id: search

                width: panes.width
                placeholder: "Search wallpapers…"
                glyph: "󰍉"
                sideKeys: true
                onDismissRequested: popup.visible = false
                onAcceptRequested: root.accept()
                onNextRequested: root.move(root.columns)
                onPrevRequested: root.move(-root.columns)
                onRightRequested: root.move(1)
                onLeftRequested: root.move(-1)
            }

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
                        color: selected ? Config.selection : catMouse.containsMouse ? Config.chrome : "transparent"

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
                            color: catRow.selected || catMouse.containsMouse ? Config.textPrimary : Config.textSecondary
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize
                        }

                        Text {
                            id: catCount

                            anchors.right: parent.right
                            anchors.rightMargin: Theme.pad
                            anchors.verticalCenter: parent.verticalCenter
                            text: catRow.modelData.count
                            color: Config.textMuted
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
                    color: Config.chrome
                }

                GridView {
                    id: grid

                    width: 480
                    height: 460
                    clip: true
                    cellWidth: width / root.columns
                    cellHeight: 104
                    model: root.filtered

                    ScrollBar.vertical: ThinScrollBar {}

                    delegate: Item {
                        id: cell

                        required property var modelData
                        required property int index

                        width: grid.cellWidth
                        height: grid.cellHeight

                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 2
                            color: cell.index === root.selected ? Config.selection : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.durFast
                                }
                            }
                        }

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
                                text: (root.currentCategory === "" ? cell.modelData.category + " / " : "") + cell.modelData.name.replace(/[_-]/g, " ")
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                                color: cellMouse.containsMouse ? Config.textPrimary : Config.textSecondary
                                font.family: Config.fontFamily
                                font.pixelSize: Theme.fontSm
                            }
                        }

                        MouseArea {
                            id: cellMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selected = cell.index;
                                root.pick(cell.modelData.path);
                            }
                        }
                    }
                }
            }
        }
    }
}
