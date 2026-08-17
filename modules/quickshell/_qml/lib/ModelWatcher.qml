import QtQuick

QtObject {
    id: root

    required property var model
    property int rev: 0

    readonly property Connections conn: Connections {
        target: root.model

        function onObjectInsertedPost() {
            root.rev++;
        }

        function onObjectRemovedPost() {
            root.rev++;
        }
    }
}
