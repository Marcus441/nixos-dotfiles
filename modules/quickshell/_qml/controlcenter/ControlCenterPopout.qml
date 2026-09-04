import QtQuick
import qs.lib
import qs.services
import qs.controlcenter

BarPopup {
    id: root

    property string expandedSection: ""

    function toggleSection(section: string): void {
        expandedSection = expandedSection === section ? "" : section;
    }

    title: "Control Center"
    minWidth: 280
    visible: false

    onVisibleChanged: {
        if (!visible)
            expandedSection = "";
    }

    Binding {
        target: NetworkService.wifiDevice
        property: "scannerEnabled"
        value: root.visible
        when: NetworkService.wifiDevice !== null
    }

    ControlCenterContent {
        host: root
        onDismissRequested: root.visible = false
    }
}
