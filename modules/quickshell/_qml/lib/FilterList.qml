import QtQuick
import QtQuick.Controls
import qs

Column {
    id: root

    signal dismissed
    signal accepted
    signal collapsed
    signal expanded

    property var filterFn: q => []
    property var selectFn: null
    property var filtered: []
    property int selected: 0
    property string placeholder: ""
    property string searchIcon: ""
    property bool treeKeys: false
    property int searchPixelSize: Theme.fontLg
    property alias delegate: list.delegate
    readonly property alias query: search.text

    function selectNext() {
        selected = Math.max(0, Math.min(filtered.length - 1, selected + 1));
    }

    function selectPrev() {
        selected = Math.max(0, selected - 1);
    }

    function refilter() {
        const q = search.text.toLowerCase();
        filtered = filterFn(q);
        selected = selectFn ? selectFn(filtered, q) : 0;
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
                Keys.onUpPressed: root.selectPrev()
                Keys.onDownPressed: root.selectNext()
                Keys.onReturnPressed: root.accepted()
                Keys.onPressed: event => {
                    if (event.modifiers !== Qt.ControlModifier)
                        return;
                    switch (event.key) {
                    case Qt.Key_N:
                        root.selectNext();
                        break;
                    case Qt.Key_P:
                        root.selectPrev();
                        break;
                    case Qt.Key_Y:
                        root.accepted();
                        break;
                    case Qt.Key_H:
                        if (!root.treeKeys)
                            return;
                        root.collapsed();
                        break;
                    case Qt.Key_L:
                        if (!root.treeKeys)
                            return;
                        root.expanded();
                        break;
                    default:
                        return;
                    }
                    event.accepted = true;
                }

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
