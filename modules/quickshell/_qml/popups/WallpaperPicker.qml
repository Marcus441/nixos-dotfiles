import Quickshell
import Quickshell.Io
import QtQuick
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
        anchors.margins: 12
        spacing: 10
        focus: true
        Keys.onEscapePressed: root.dismissed()

        Row {
            spacing: 16

            Text {
                text: "Wallpapers"
                color: Config.base05
                font.family: Config.fontFamily
                font.pixelSize: Config.fontSize + 4
            }

            Text {
                text: root.rotatorEnabled ? "󰒝 shuffle on" : "󰒝 shuffle off"
                color: root.rotatorEnabled ? Config.base0D : Config.base04
                font.family: Config.iconFamily
                font.pixelSize: Config.fontSize
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.toggleRotator()
                }
            }
        }

        GridView {
            id: grid

            width: parent.width
            height: parent.height - 40
            clip: true
            cellWidth: 196
            cellHeight: 130
            model: root.walls

            delegate: Item {
                id: cell

                required property string modelData

                width: grid.cellWidth
                height: grid.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: 6
                    color: Config.base01
                    border.color: cellMouse.containsMouse ? Config.base0D : Config.base02
                    border.width: 1

                    Image {
                        anchors.fill: parent
                        anchors.margins: 3
                        source: "file://" + cell.modelData
                        sourceSize.width: 240
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.margins: 3
                        height: 18
                        color: Qt.alpha(Config.base00, 0.8)

                        Text {
                            anchors.centerIn: parent
                            width: parent.width - 8
                            text: root.prettyName(cell.modelData)
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                            color: Config.base05
                            font.family: Config.fontFamily
                            font.pixelSize: Config.fontSize - 2
                        }
                    }

                    MouseArea {
                        id: cellMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.pick(cell.modelData)
                    }
                }
            }
        }
    }
}
