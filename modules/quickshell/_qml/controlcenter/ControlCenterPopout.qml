import qs.lib

BarPopup {
    id: root

    title: "Control Center"
    minWidth: 280
    visible: false

    ControlCenterContent {
        onDismissRequested: root.visible = false
    }
}
