import QtQuick
import QtQuick.Controls
import qs

Column {
    id: root

    signal dismissed
    signal accepted

    property var filterFn: q => []
    property var filtered: []
    property int selected: 0
    property string placeholder: ""
    property string searchIcon: ""
    property int searchPixelSize: Theme.fontLg
    property alias delegate: list.delegate

    function refilter() {
        filtered = filterFn(search.text.toLowerCase());
        selected = 0;
    }

    spacing: 0

    Component.onCompleted: refilter()

    Rectangle {
        id: searchBox

        width: parent.width
        height: search.implicitHeight + 24
        color: Config.base01

        Row {
            anchors.fill: parent
            anchors.leftMargin: Theme.pad
            anchors.rightMargin: Theme.pad
            spacing: Theme.gap

            Text {
                id: icon

                visible: root.searchIcon !== ""
                text: root.searchIcon
                color: Config.base04
                font.family: Config.iconFamily
                font.pixelSize: root.searchPixelSize
                anchors.verticalCenter: parent.verticalCenter
            }

            TextInput {
                id: search

                width: parent.width - (icon.visible ? parent.spacing + icon.width : 0)
                color: Config.base05
                font.family: Config.fontFamily
                font.pixelSize: root.searchPixelSize
                focus: true
                anchors.verticalCenter: parent.verticalCenter
                onTextChanged: root.refilter()
                Keys.onEscapePressed: root.dismissed()
                Keys.onUpPressed: root.selected = Math.max(0, root.selected - 1)
                Keys.onDownPressed: root.selected = Math.min(root.filtered.length - 1, root.selected + 1)
                Keys.onReturnPressed: root.accepted()

                Text {
                    visible: search.text === ""
                    text: root.placeholder
                    color: Config.base03
                    font: search.font
                }
            }
        }
    }

    ListView {
        id: list

        width: parent.width
        height: parent.height - searchBox.height
        topMargin: Theme.gap
        bottomMargin: Theme.gap
        clip: true
        model: root.filtered
        currentIndex: root.selected
        highlightMoveDuration: 80

        ScrollBar.vertical: ThinScrollBar {}
    }
}
