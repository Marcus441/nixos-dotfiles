import QtQuick
import QtQuick.Controls
import qs
import qs.lib

Column {
    id: root

    signal dismissed
    signal accepted
    signal collapsed
    signal expanded
    signal deleted

    property var filterFn: q => []
    property var selectFn: null
    property var filtered: []
    property int selected: 0
    property string placeholder: ""
    property string emptyText: "No matches"
    property string searchIcon: ""
    property bool treeKeys: false
    property bool deleteKeys: false
    property int searchPixelSize: Theme.fontLg
    property alias delegate: list.delegate
    readonly property alias query: searchBox.text
    readonly property int rowWidth: list.width

    function selectNext() {
        selected = Math.max(0, Math.min(filtered.length - 1, selected + 1));
    }

    function selectPrev() {
        selected = Math.max(0, selected - 1);
    }

    function refilter() {
        const q = searchBox.text.toLowerCase();
        filtered = filterFn(q);
        selected = selectFn ? selectFn(filtered, q) : 0;
    }

    spacing: 0

    Component.onCompleted: refilter()

    SearchField {
        id: searchBox

        width: parent.width
        placeholder: root.placeholder
        glyph: root.searchIcon
        pixelSize: root.searchPixelSize
        sideKeys: root.treeKeys
        deleteKeys: root.deleteKeys
        onTextChanged: root.refilter()
        onDismissRequested: root.dismissed()
        onAcceptRequested: root.accepted()
        onNextRequested: root.selectNext()
        onPrevRequested: root.selectPrev()
        onLeftRequested: root.collapsed()
        onRightRequested: root.expanded()
        onDeleteRequested: root.deleted()
    }

    Item {
        width: parent.width
        height: parent.height - searchBox.height

        ListView {
            id: list

            anchors.fill: parent
            anchors.leftMargin: Theme.gap
            anchors.rightMargin: Theme.gap
            topMargin: Theme.gap
            bottomMargin: Theme.gap
            clip: true
            model: root.filtered
            currentIndex: root.selected
            highlightMoveDuration: 80

            ScrollBar.vertical: ThinScrollBar {}
        }

        Text {
            anchors.centerIn: parent
            visible: root.filtered.length === 0
            text: root.emptyText
            color: Config.textMuted
            font.family: Config.fontFamily
            font.pixelSize: Config.fontSize
        }
    }
}
