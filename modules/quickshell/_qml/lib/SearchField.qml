import QtQuick
import qs

Rectangle {
    id: root

    signal dismissRequested
    signal acceptRequested
    signal nextRequested
    signal prevRequested
    signal leftRequested
    signal rightRequested

    property string placeholder: ""
    property string glyph: ""
    property int pixelSize: Theme.fontLg
    property bool sideKeys: false
    property alias text: input.text

    height: input.implicitHeight + 24
    color: "transparent"

    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.pad
        anchors.rightMargin: Theme.pad
        spacing: Theme.gap

        Text {
            id: glyphText

            visible: root.glyph !== ""
            text: root.glyph
            color: Config.textSecondary
            font.family: Config.iconFamily
            font.pixelSize: root.pixelSize
            anchors.verticalCenter: parent.verticalCenter
        }

        TextInput {
            id: input

            width: parent.width - (glyphText.visible ? parent.spacing + glyphText.width : 0)
            color: Config.textPrimary
            font.family: Config.fontFamily
            font.pixelSize: root.pixelSize
            focus: true
            anchors.verticalCenter: parent.verticalCenter
            Keys.onEscapePressed: root.dismissRequested()
            Keys.onUpPressed: root.prevRequested()
            Keys.onDownPressed: root.nextRequested()
            Keys.onReturnPressed: root.acceptRequested()
            Keys.onEnterPressed: root.acceptRequested()
            Keys.onPressed: event => {
                if (event.modifiers !== Qt.ControlModifier)
                    return;
                switch (event.key) {
                case Qt.Key_N:
                    root.nextRequested();
                    break;
                case Qt.Key_P:
                    root.prevRequested();
                    break;
                case Qt.Key_Y:
                    root.acceptRequested();
                    break;
                case Qt.Key_H:
                    if (!root.sideKeys)
                        return;
                    root.leftRequested();
                    break;
                case Qt.Key_L:
                    if (!root.sideKeys)
                        return;
                    root.rightRequested();
                    break;
                default:
                    return;
                }
                event.accepted = true;
            }

            Text {
                visible: input.text === ""
                text: root.placeholder
                color: Config.textMuted
                font: input.font
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: Theme.pad
        anchors.rightMargin: Theme.pad
        height: 1
        color: Config.chrome
    }
}
