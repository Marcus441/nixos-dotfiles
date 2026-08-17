pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import qs
import qs.lib

Overlay {
    id: root

    contentWidth: 820
    contentHeight: 560

    property var walls: []
    property bool rotatorEnabled: false

    function prettyName(path) {
        const parts = path.slice(Config.wallsDir.length + 1).split("/");
        const file = parts[parts.length - 1].replace(/\.[^.]+$/, "");
        const parent = parts.length > 1 ? parts[parts.length - 2] : "";
        return `${parent} / ${file}`.replace(/[_-]/g, " ");
    }

    function pick(path) {
        Quickshell.execDetached([Config.setWallpaperScript, path]);
        root.dismissed();
    }

    function toggleRotator() {
        rotatorToggle.command = [root.rotatorEnabled ? Config.disableRotatorScript : Config.enableRotatorScript];
        rotatorToggle.running = true;
    }

    Process {
        id: findProc

        command: [Config.fd, "-t", "f", "-e", "jpg", "-e", "jpeg", "-e", "png", "-e", "webp", ".", Config.wallsDir]
        running: true

        stdout: StdioCollector {
            onStreamFinished: root.walls = text.split("\n").filter(line => line !== "").sort()
        }
    }

    Process {
        id: rotatorToggle

        onExited: rotatorCheck.running = true
    }

    Process {
        id: rotatorCheck

        command: [Config.sh, "-c", "test -f \"${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper_rotator_enabled\""]
        running: true

        onExited: exitCode => root.rotatorEnabled = exitCode === 0
    }

    Column {
        anchors.fill: parent
        spacing: 0
        focus: true
        Keys.onEscapePressed: root.dismissed()

        Rectangle {
            id: header

            width: parent.width
            height: title.implicitHeight + 24
            color: Config.base01

            Row {
                anchors.fill: parent
                anchors.leftMargin: Theme.pad
                anchors.rightMargin: Theme.pad
                spacing: 16

                Text {
                    id: title

                    text: "Wallpapers"
                    color: Config.base05
                    font.family: Config.fontFamily
                    font.pixelSize: Theme.fontLg
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextAction {
                    text: root.rotatorEnabled ? "󰒝 shuffle on" : "󰒝 shuffle off"
                    active: root.rotatorEnabled
                    anchors.verticalCenter: parent.verticalCenter
                    onTriggered: root.toggleRotator()
                }
            }
        }

        GridView {
            id: grid

            width: parent.width
            height: parent.height - header.height
            topMargin: 10
            bottomMargin: 10
            leftMargin: 10
            rightMargin: 10
            clip: true
            cellWidth: (width - leftMargin - rightMargin) / 4
            cellHeight: 144
            model: root.walls

            ScrollBar.vertical: ThinScrollBar {}

            delegate: Item {
                id: cell

                required property string modelData

                width: grid.cellWidth
                height: grid.cellHeight

                Column {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4

                    Image {
                        width: parent.width
                        height: parent.height - label.height - parent.spacing
                        source: "file://" + cell.modelData
                        sourceSize.width: 240
                        fillMode: Image.PreserveAspectCrop
                        clip: true
                        asynchronous: true
                        opacity: cellMouse.containsMouse ? 1 : 0.82

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 120
                            }
                        }
                    }

                    Text {
                        id: label

                        width: parent.width
                        text: root.prettyName(cell.modelData)
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
                    onClicked: root.pick(cell.modelData)
                }
            }
        }
    }
}
